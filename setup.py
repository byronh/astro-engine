from Cython.Build import cythonize
from multiprocessing import pool
from setuptools import Extension, setup
import distutils.ccompiler
import os
import subprocess
import sys

DEBUG = True
PROJECT_NAME = 'astro'


def main():
    """ Compile the c++ and cython sources, then package whole engine as a python module """

    extra_compile_args = ['-std=c++14']
    extra_link_args = ['-std=c++14']
    undef_macros = []
    if DEBUG:
        extra_compile_args += ['-Wall', '-Werror', '-Wno-unused-function']
        extra_link_args += ['-g']
        undef_macros += ['NDEBUG']

    modules = Extension(
        extra_compile_args=extra_compile_args,
        extra_link_args=extra_link_args,
        name='*',
        include_dirs=['src'],
        language='c++',
        sources=['{}/**/*.pyx'.format(PROJECT_NAME)],
        undef_macros=undef_macros
    )

    fix_distutils()
    distutils.ccompiler.CCompiler.compile = parallel_compile
    use_ccache()

    setup(
        name=PROJECT_NAME,
        author='Byron Henze',
        author_email='byronh@gmail.com',
        url='https://github.com/byronh/astro-engine',
        version='0.1',
        packages=[PROJECT_NAME],
        ext_modules=cythonize([modules])
    )


def fix_distutils():
    """ Fix the annoying warnings caused by distutils bug """
    import distutils.sysconfig

    cfg_vars = distutils.sysconfig.get_config_vars()
    if 'CFLAGS' in cfg_vars:
        cfg_vars['CFLAGS'] = cfg_vars['CFLAGS'].replace('-Wstrict-prototypes', '')


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
    args = sys.argv[1:]

    # Make a `cleanall` rule to get rid of intermediate and library files
    if 'clean' in args:
        subprocess.Popen('rm -rf build', shell=True, executable='/bin/bash')
        subprocess.Popen('find ./{} -name "*.cpp" -type f -print -delete'.format(PROJECT_NAME),
                         shell=True, executable='/bin/bash')
        subprocess.Popen('find ./{} -name "*.so" -type f -print -delete'.format(PROJECT_NAME),
                         shell=True, executable='/bin/bash')

    # We want to always use build_ext --inplace
    if args.count('build_ext') > 0 and args.count('--inplace') == 0:
        sys.argv.insert(sys.argv.index('build_ext') + 1, '--inplace')

    # Only build for 64-bit target
    os.environ['ARCHFLAGS'] = '-arch x86_64'

    main()