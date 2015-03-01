cdef extern from "graphics/shader.h":
    cppclass cShader "Shader":
        const unsigned int handle
        cShader(const char* vertex_source, const char* fragment_source)
        void begin()
        int get_attribute_location(const char* name)
        int get_uniform_location(const char* name)


cdef class Shader:
    cdef cShader* s