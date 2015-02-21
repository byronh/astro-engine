cdef extern from "core/math.h":

    cppclass Vector3:
        float x, y, z
        Vector3(float x, float y, float z)