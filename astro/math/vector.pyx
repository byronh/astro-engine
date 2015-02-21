cdef class Vector3:

    def __init__(self, x=0, y=0, z=0):
        self.v.x = x
        self.v.y = y
        self.v.z = z

    def __repr__(self):
        return c_math.to_string(self.v).decode('utf-8')