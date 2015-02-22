from astro.math cimport matrix
from camera cimport Camera


cdef class Renderer:

    def add_component(self, entity_id, model_id, matrix.Matrix4 transform):
        self.r.add_component(entity_id, model_id, transform.m)

    def initialize(self):
        self.r.initialize()

    def render(self, Camera camera):
        self.r.render(&camera.c)

    def shutdown(self):
        self.r.shutdown()