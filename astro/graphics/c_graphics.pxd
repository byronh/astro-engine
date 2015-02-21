from astro.math cimport c_math


cdef extern from "graphics/camera.h":

    cppclass Camera:
        c_math.Matrix4 projection
        c_math.Matrix4 view
        Camera()
        Camera(const c_math.Matrix4& projection, const c_math.Matrix4& view)