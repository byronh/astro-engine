import os
from astro.native import graphics


class NoGLContextException(Exception):
    def __init__(self):
        super().__init__('OpenGL context is required')


class RenderSystem:
    def __init__(self):
        self.initialized = False
        self.rs = graphics.RenderSystem()
        self.shaders = {}

    def __del__(self):
        self.cleanup()

    def cleanup(self):
        del self.rs

    def initialize(self):
        self.rs.initialize()
        self.initialized = True

    def render(self):
        self.rs.render()

    def load_shader(self, vertex_shader_path: str, fragment_shader_path: str):
        if not self.initialized:
            raise NoGLContextException
        if not os.path.isfile(vertex_shader_path):
            raise FileNotFoundError(vertex_shader_path)
        if not os.path.isfile(fragment_shader_path):
            raise FileNotFoundError(fragment_shader_path)

        with open(vertex_shader_path, 'r') as f:
            vert = f.read()
        with open(fragment_shader_path, 'r') as f:
            frag = f.read()

        shader = graphics.Shader(vert, frag)
        self.shaders[shader.handle] = shader

        print("Loaded shader program: {} -> {}".format(shader.handle, [vertex_shader_path, fragment_shader_path]))
        return shader