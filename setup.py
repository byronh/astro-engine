from distutils.command.build import build
from multiprocessing import pool
from setuptools import Extension, setup
from setuptools.command.install import install
import distutils.ccompiler
import os
import subprocess


DEBUG = True
PROJECT_NAME = 'astro'


class GameModule(Extension):
    def __init__(self, name: str, sources: list, libraries: list=None, cpp: bool=True):
        extra_compile_args = ['-std=c++14'] if cpp else ['-std=c11']
        if not isinstance(libraries, list):
            libraries = []
        undef_macros = []
        if DEBUG:
            extra_compile_args += ['-Wall', '-Werror']
            undef_macros += ['NDEBUG']
        super().__init__(
            name='{}.native.{}'.format(PROJECT_NAME, name),
            sources=['src/{}'.format(file) for file in sources],
            include_dirs=['src/{}'.format(name)],
            libraries=libraries,
            extra_compile_args=extra_compile_args,
            undef_macros=undef_macros,
        )


def main():
    """ Build the whole engine as a python package """

    # Speed up compile times
    distutils.ccompiler.CCompiler.compile = parallel_compile
    use_ccache()

    ecs = GameModule(
        name='ecs',
        sources=['ecs/entity_manager.cpp', 'ecs/entity_manager_py.cpp']
    )

    window = GameModule(
        name='window',
        sources=['window/window.c', 'window/window_py.c'],
        libraries=['glfw'],
        cpp=False
    )

    setup(
        cmdclass={'build': SwigBuild, 'install': SwigInstall},
        name=PROJECT_NAME,
        author='Byron Henze',
        author_email='byronh@gmail.com',
        version='0.1',
        packages=[PROJECT_NAME],
        ext_modules=[ecs, window]
    )


class SwigBuild(build):
    """ Make sure that swig files are generated and copied before the build command """

    def run(self):
        self.run_command('build_ext')
        build.run(self)


class SwigInstall(install):
    """ Make sure that swig files are generated and copied before the install command """

    def run(self):
        self.run_command('build_ext')
        self.do_egg_install()


def parallel_compile(self, sources, output_dir=None, macros=None, include_dirs=None, debug=0, extra_preargs=None,
                     extra_postargs=None, depends=None):
    """ Monkey patch function to allow distutils to compile c++ code in parallel. """
    macros, objects, extra, opts, builds = self._setup_compile(output_dir, macros, include_dirs, sources,
                                                               depends, extra_postargs)
    cc_args = self._get_cc_args(opts, debug, extra_preargs)
    num_threads = 4

    def single_compile(obj):
        if obj in builds:
            src, ext = builds[obj]
            self._compile(obj, src, ext, cc_args, extra, opts)

    list(pool.ThreadPool(num_threads).imap(single_compile, objects))
    return objects


def use_ccache():
    """ Use ccache to speed up c++ compile times, if available """
    result = subprocess.call(['which', 'ccache'])
    if result == 0:
        os.environ['CC'] = 'ccache gcc'


if __name__ == '__main__':
    main()