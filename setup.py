from distutils.command.build import build
from multiprocessing import pool
from setuptools import Extension, setup
from setuptools.command.install import install
import distutils.ccompiler
import os
import subprocess


PROJECT_NAME = 'astro'


def main():
    """ Build the whole engine as a python package """

    # Speed up compile times
    distutils.ccompiler.CCompiler.compile = parallel_compile
    use_ccache()

    ecs_ext = Extension(
        name='astro.native.ecs',
        sources=['src/ecs/entity_manager.cpp', 'src/ecs/entity_manager_py.cpp'],
        include_dirs=['src/ecs'],
        extra_compile_args=['-std=c++14', '-Wall', '-Werror'],
        undef_macros=['NDEBUG']
    )

    window_ext = Extension(
        name='astro.native.window',
        sources=['src/platform/window.c', 'src/platform/window_py.c'],
        include_dirs=['src/platform'],
        libraries=['glfw'],
        extra_compile_args=['-std=c11', '-Wall', '-Werror'],
        undef_macros=['NDEBUG']
    )

    setup(
        cmdclass={'build': SwigBuild, 'install': SwigInstall},
        name=PROJECT_NAME,
        author='Byron Henze',
        author_email='byronh@gmail.com',
        version='0.1',
        packages=[PROJECT_NAME],
        ext_modules=[ecs_ext, window_ext]
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