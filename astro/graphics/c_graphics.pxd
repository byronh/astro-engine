from astro.math cimport c_math


cdef extern from "graphics/camera.h":

    cppclass Camera:
        c_math.Matrix4 projection
        c_math.Matrix4 view
        c_math.Vector3 direction
        c_math.Vector3 position
        c_math.Vector3 up

        Camera()

        void look_at(const c_math.Vector3& target)
        void move(const c_math.Vector3& displacement)
        void rotate(const c_math.Vector3& axis, float angle)
        void update()


cdef extern from "graphics/renderer.h":

    cppclass Renderer:
        void add_component(unsigned int entity_id, unsigned int model_id, c_math.Matrix4 transform)
        void initialize()
        void render(Camera* camera)
        void shutdown()


cdef extern from "graphics/shader.h":

    cppclass Shader:
        const unsigned int handle
        Shader(const char* vertex_source, const char* fragment_source)
        void begin()
        int get_attribute_location(const char* name)
        int get_uniform_location(const char* name)