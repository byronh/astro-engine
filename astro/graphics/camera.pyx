from astro.math cimport c_math, matrix, vector


cdef class Camera:

    def __init__(self, matrix.Matrix4 projection):
        self.c.projection = projection.m

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
            mat.m = self.c.projection * self.c.view
            return mat

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