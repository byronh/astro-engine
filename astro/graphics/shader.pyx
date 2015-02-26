# distutils: libraries = GLEW
# distutils: sources = src/graphics/shader.cpp src/graphics/gl.cpp

cimport c_graphics
import os


cdef class Shader:

    def __cinit__(self):
        self.s = NULL

    def __dealloc__(self):
        del self.s

    def __init__(self, vertex_shader_path, fragment_shader_path):
        if not os.path.isfile(vertex_shader_path):
            raise FileNotFoundError(vertex_shader_path)
        if not os.path.isfile(fragment_shader_path):
            raise FileNotFoundError(fragment_shader_path)

        with open(vertex_shader_path, 'r') as f:
            vert = f.read()
        with open(fragment_shader_path, 'r') as f:
            frag = f.read()

        vert = vert.encode('utf-8')
        frag = frag.encode('utf-8')

        self.s = new c_graphics.Shader(vert, frag)
        print("Loaded shader program: {} -> {}".format(self.s.handle, [vertex_shader_path, fragment_shader_path]))

    def begin(self):
        self.s.begin()

    def get_uniform_location(self, name):
        return self.s.get_uniform_location(name.encode('utf-8'))