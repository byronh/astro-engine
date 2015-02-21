cimport c_graphics


cdef class Shader:
    cdef c_graphics.Shader* s