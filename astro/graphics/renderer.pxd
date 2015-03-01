from astro.math cimport c_math
from camera cimport cCamera


cdef extern from "graphics/renderer.h":
    cppclass cRenderer "Renderer":
        void add_component(unsigned int entity_id, unsigned int model_id, c_math.Matrix4 transform)
        void initialize()
        void render(cCamera* camera)
        void shutdown()


cdef class Renderer:
    cdef cRenderer r