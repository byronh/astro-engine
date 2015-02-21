from camera cimport Camera


cdef class RenderSystem:

    def __init__(self, Camera camera):
        self.rs.camera = &camera.c
        self.rs.initialize()

    def render(self):
        self.rs.render()