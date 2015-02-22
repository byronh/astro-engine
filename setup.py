from Cython.Build import cythonize
from multiprocessing import pool
from setuptools import Extension, setup
import distutils.ccompiler


DEBUG = True
PROJECT_NAME = 'astro'


def main():
    """ Build the whole engine as a python package """

    module('core.entitymanager', cpp=['core/entitymanager'])
    module('graphics.camera', cpp=['graphics/camera'])
    module('math.vector')
    module('math.matrix')
    module('graphics.renderer',
           cpp=['graphics/camera', 'graphics/gl', 'graphics/model', 'graphics/renderer'],
           libraries=['GLEW'])
    module('graphics.shader', cpp=['graphics/shader', 'graphics/gl'], libraries=['GLEW'])
    module('window', libraries=['glfw'], macros=[('GLFW_INCLUDE_NONE', None)])

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
        ext_modules=cythonize(all_modules)
    )


def module(name: str, cpp: list=None, libraries: list=None, macros: list=None):
    name = '{}.{}'.format(PROJECT_NAME, name)

    extra_compile_args = ['-std=c++14']
    extra_link_args = ['-std=c++14']

    if not isinstance(libraries, list):
        libraries = []
    if not isinstance(macros, list):
        macros = []

    undef_macros = []
    sources = ['{}.pyx'.format(name.replace('.', '/'))]
    if cpp:
        sources += ['src/{}.cpp'.format(path) for path in cpp]
    print(name, sources)
    if DEBUG:
        extra_compile_args += ['-Wall', '-Werror', '-Wno-unused-function']
        extra_link_args += ['-g']
        undef_macros += ['NDEBUG']

    all_modules.append(Extension(
        name=name,
        define_macros=macros,
        extra_compile_args=extra_compile_args,
        extra_link_args=extra_link_args,
        include_dirs=['src'],
        language='c++',
        libraries=libraries,
        sources=sources,
        undef_macros=undef_macros,
    ))


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
    import os
    import subprocess

    result = subprocess.call(['which', 'ccache'])
    if result == 0:
        os.environ['CC'] = 'ccache gcc'


if __name__ == '__main__':
    all_modules = []
    main()