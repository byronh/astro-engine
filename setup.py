from Cython.Build import cythonize
from multiprocessing import pool
from setuptools import Extension, setup
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

    module('core.entitymanager', native=['core/entitymanager'])
    module('graphics.camera', cython=['math/matrix'], native=['graphics/camera'])
    module('graphics.renderer',
           native=['graphics/camera', 'graphics/gl', 'graphics/model', 'graphics/renderer'],
           libraries=['GLEW'])
    module('graphics.shader', native=['graphics/shader', 'graphics/gl'], libraries=['GLEW'])
    module('math.vector')
    module('math.matrix')
    module('window', cpp=False, libraries=['glfw'])

    setup(
        name=PROJECT_NAME,
        author='Byron Henze',
        author_email='byronh@gmail.com',
        version='0.1',
        packages=[PROJECT_NAME],
        ext_modules=cythonize(_modules)
    )


def module(name: str, cython: list=None, native: list=None, libraries: list=None, cpp: bool=True):
    name = '{}.{}'.format(PROJECT_NAME, name)

    if cpp:
        extra_compile_args = ['-std=c++14']
        extra_link_args = ['-std=c++14']
        language = 'c++'
    else:
        extra_compile_args = ['-std=c11']
        extra_link_args = ['-std=c11']
        language = 'c'

    if not isinstance(libraries, list):
        libraries = []

    undef_macros = []
    sources = ['{}.pyx'.format(name.replace('.', '/'))]
    if cython:
        sources += ['{}/{}.pyx'.format(PROJECT_NAME, path) for path in cython]
    if native:
        sources += ['src/{}.{}'.format(path, 'cpp' if cpp else 'c') for path in native]
    print(name, sources)
    if DEBUG:
        extra_compile_args += ['-Wall', '-Werror', '-Wno-unused-function']
        extra_link_args += ['-g']
        undef_macros += ['NDEBUG']

    _modules.append(Extension(
        name=name,
        extra_compile_args=extra_compile_args,
        extra_link_args=extra_link_args,
        include_dirs=['src'],
        language=language,
        libraries=libraries,
        sources=sources,
        undef_macros=undef_macros,
    ))


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
    _modules = []
    main()