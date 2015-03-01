# distutils: sources = src/graphics/camera.cpp

from astro.math cimport c_math, matrix, vector


cdef class Camera:

    def __cinit__(self):
        self.c = NULL

    def __dealloc__(self):
        del self.c

    def __init__(self, float viewport_width, float viewport_height):
        self.c = new cCamera(viewport_width, viewport_height)

    def look_at(self, vector.Vector3 target):
        self.c.look_at(target.v)

    def move(self, vector.Vector3 displacement):
        self.c.move(displacement.v)

    def move_to(self, vector.Vector3 destination):
        self.c.position = destination.v

    def pitch(self, float amount):
        cdef c_math.Vector3 right = c_math.cross(self.c.direction, self.c.up)
        self.c.rotate(right, amount)

    def roll(self, float amount):
        self.c.rotate(self.c.direction, amount)

    def rotate(self, vector.Vector3 axis, float angle):
        self.c.rotate(axis.v, angle)

    def set_viewport(self, int width, int height):
        self.c.viewport_width = width
        self.c.viewport_height = height

    def step(self, float amount):
        cdef c_math.Vector3 vec = c_math.normalize(self.c.direction) * amount
        self.c.move(vec)

    def strafe(self, float amount):
        cdef c_math.Vector3 vec = c_math.cross(self.c.direction, self.c.up)
        vec = c_math.normalize(vec) * amount
        self.c.move(vec)

    def update(self):
        self.c.update()

    property combined:
        def __get__(Camera self):
            cdef matrix.Matrix4 mat = matrix.Matrix4()
            mat.m = self.c.combined
            return mat

    property projection:
        def __get__(Camera self):
            cdef matrix.Matrix4 mat = matrix.Matrix4()
            mat.m = self.c.projection
            return mat

    property view:
        def __get__(Camera self):
            cdef matrix.Matrix4 mat = matrix.Matrix4()
            mat.m = self.c.view
            return mat