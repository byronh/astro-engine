from astro.math cimport matrix


cdef class Camera:

    def __init__(self, matrix.Matrix4 projection, matrix.Matrix4 view):
        self.c.projection = projection.m
        self.c.view = view.m

    property projection:
        def __get__(Camera self):
            cdef matrix.Matrix4 mat = matrix.Matrix4()
            mat.m = self.c.projection
            return mat
        def __set__(Camera self, matrix.Matrix4 value):
            self.c.projection = value.m

    property view:
        def __get__(Camera self):
            cdef matrix.Matrix4 mat = matrix.Matrix4()
            mat.m = self.c.view
            return mat
        def __set__(Camera self, matrix.Matrix4 value):
            self.c.view = value.m