from astro.math cimport c_math


cdef extern from "graphics/camera.h":

    cppclass Camera:
        c_math.Matrix4 projection
        c_math.Matrix4 view
        Camera()
        Camera(const c_math.Matrix4& projection, const c_math.Matrix4& view)


cdef extern from "graphics/rendersystem.h":

    cppclass RenderSystem:
        Camera* camera
        void initialize()
        void render()


cdef extern from "graphics/shader.h":

    cppclass Shader:
        const unsigned int handle
        Shader(const char* vertex_source, const char* fragment_source)
        void begin()
        int get_attribute_location(const char* name)
        int get_uniform_location(const char* name)