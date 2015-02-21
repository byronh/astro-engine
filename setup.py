from Cython.Build import cythonize
from distutils.command.build import build
from multiprocessing import pool
from setuptools import Extension, setup
from setuptools.command.install import install
import distutils.ccompiler
import os
import subprocess


DEBUG = True
PROJECT_NAME = 'astro'


def main():
    """ Build the whole engine as a python package """

    # Speed up compile times
    distutils.ccompiler.CCompiler.compile = parallel_compile
    use_ccache()

    entity_manager = Extension(
        extra_compile_args=['-Wall', '-Werror', '-Wno-unused-function'],
        extra_link_args=["-g"],
        include_dirs=['src'],
        language='c++',
        name='astro.core.entitymanager',
        sources=['astro/core/entitymanager.pyx', 'src/core/entitymanager.cpp'],
        undef_macros=['NDEBUG']
    )

    camera = Extension(
        extra_compile_args=['-Wall', '-Werror', '-Wno-unused-function'],
        extra_link_args=["-g"],
        include_dirs=['src'],
        language='c++',
        name='astro.graphics.camera',
        sources=['astro/math/matrix.pyx', 'astro/graphics/camera.pyx', 'src/graphics/camera.cpp'],
        undef_macros=['NDEBUG']
    )

    vector = Extension(
        extra_compile_args=['-Wall', '-Werror', '-Wno-unused-function'],
        extra_link_args=["-g"],
        include_dirs=['src'],
        language='c++',
        name='astro.math.vector',
        sources=['astro/math/vector.pyx'],
        undef_macros=['NDEBUG']
    )

    matrix = Extension(
        extra_compile_args=['-Wall', '-Werror', '-Wno-unused-function'],
        extra_link_args=["-g"],
        include_dirs=['src'],
        language='c++',
        name='astro.math.matrix',
        sources=['astro/math/matrix.pyx'],
        undef_macros=['NDEBUG']
    )

    rendersystem = Extension(
        extra_compile_args=['-std=c++14', '-Wall', '-Werror', '-Wno-unused-function'],
        extra_link_args=['-std=c++14', '-g'],
        include_dirs=['src'],
        language='c++',
        libraries=['GLEW'],
        name='astro.graphics.rendersystem',
        sources=['astro/graphics/rendersystem.pyx', 'src/graphics/rendersystem.cpp', 'src/graphics/camera.cpp',
                 'src/graphics/gl.cpp'],
        undef_macros=['NDEBUG']
    )

    shader = Extension(
        extra_compile_args=['-std=c++14', '-Wall', '-Werror', '-Wno-unused-function'],
        extra_link_args=['-std=c++14', '-g'],
        include_dirs=['src'],
        language='c++',
        libraries=['GLEW'],
        name='astro.graphics.shader',
        sources=['astro/graphics/shader.pyx', 'src/graphics/shader.cpp', 'src/graphics/gl.cpp'],
        undef_macros=['NDEBUG']
    )

    window = Extension(
        extra_compile_args=['-Wall', '-Werror', '-Wno-unused-function'],
        extra_link_args=["-g"],
        name='astro.window',
        libraries=['glfw'],
        sources=['astro/window.pyx'],
        undef_macros=['NDEBUG']
    )

    setup(
        cmdclass={'build': SwigBuild, 'install': SwigInstall},
        name=PROJECT_NAME,
        author='Byron Henze',
        author_email='byronh@gmail.com',
        version='0.1',
        packages=[PROJECT_NAME],
        ext_modules=cythonize([entity_manager, camera, vector, matrix, rendersystem, shader, window])
    )


class GameModule(Extension):
    def __init__(self, name: str, sources: list, libraries: list=None, cpp: bool=True, swig: bool=False,
                 extra_include_dirs: list=None):
        extra_compile_args = ['-std=c++14'] if cpp else ['-std=c11']
        if not isinstance(libraries, list):
            libraries = []
        if not isinstance(extra_include_dirs, list):
            extra_include_dirs = []
        undef_macros = []
        if DEBUG:
            extra_compile_args += ['-Wall', '-Werror']
            undef_macros += ['NDEBUG']
        swig_opts = None
        if swig:
            name = '_{}'.format(name)
            swig_opts = ['-c++', '-py3', '-Werror', '-outdir', '{}/native'.format(PROJECT_NAME)]
        else:
            name = '{}.native.{}'.format(PROJECT_NAME, name)
        super().__init__(
            name=name,
            sources=sources,
            include_dirs=['src'] + extra_include_dirs,
            libraries=libraries,
            extra_compile_args=extra_compile_args,
            swig_opts=swig_opts,
            undef_macros=undef_macros,
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
    num_threads = 8

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