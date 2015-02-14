from multiprocessing import pool
from setuptools import Extension, setup
import distutils.ccompiler
import os
import subprocess

PROJECT_NAME = 'astro'


def main():
    """ Build the whole engine as a python package """

    # Speed up compile times
    distutils.ccompiler.CCompiler.compile = parallel_compile
    use_ccache()

    graphics_ext = Extension(
        name='astro.native.gl',
        sources=['src/graphics/gl.c'],
        include_dirs=['src/graphics'],
        libraries=['GLEW'],
        extra_compile_args=['-std=c11', '-Wall', '-Werror']
    )

    window_ext = Extension(
        name='astro.native.window',
        sources=['src/window/window.c'],
        include_dirs=['src/window'],
        libraries=['glfw'],
        extra_compile_args=['-std=c11', '-Wall', '-Werror']
    )

    setup(
        name=PROJECT_NAME,
        author='Byron Henze',
        author_email='byronh@gmail.com',
        version='0.1',
        packages=[PROJECT_NAME],
        ext_modules=[graphics_ext, window_ext],
    )


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