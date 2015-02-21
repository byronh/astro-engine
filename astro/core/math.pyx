# distutils: language = c++

cimport cmath


cdef class Vector3:
    cdef:
        cmath.Vector3* this_ptr
        float x, y, z

    def __cinit__(self):
        self.this_ptr = NULL

    def __init__(self, x=0, y=0, z=0):
        self.this_ptr = new cmath.Vector3(x, y, z)

    def __dealloc__(self):
        del self.this_ptr

    property x:
        def __get__(Vector3 self):
            return self.this_ptr.x
        def __set__(Vector3 self, value):
            self.this_ptr.x = value

    property y:
        def __get__(Vector3 self):
            return self.this_ptr.y
        def __set__(Vector3 self, value):
            self.this_ptr.y = value

    property z:
        def __get__(Vector3 self):
            return self.this_ptr.z
        def __set__(Vector3 self, value):
            self.this_ptr.z = value