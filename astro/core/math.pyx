# cython: c_string_type=unicode, c_string_encoding=utf8
# distutils: language = c++

cimport c_math


cdef class Matrix4:
    cdef c_math.Matrix4 m;

    def __repr__(self):
        return c_math.to_string(self.m)

    @staticmethod
    def look_at(Vector3 eye, Vector3 center, Vector3 up):
        mat = Matrix4()
        mat.m = c_math.look_at(eye.v, center.v, up.v)
        return mat

    @staticmethod
    def perspective(float fov, float aspect, float near, float far):
        mat = Matrix4()
        mat.m = c_math.perspective(fov, aspect, near, far)
        return mat


cdef class Vector3:
    cdef c_math.Vector3 v;

    def __init__(self, x=0, y=0, z=0):
        self.v.x = x
        self.v.y = y
        self.v.z = z

    def __repr__(self):
        return c_math.to_string(self.v)