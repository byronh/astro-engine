from astro.math cimport c_math


cdef extern from "graphics/camera.h":
    cppclass cCamera "Camera":
        c_math.Matrix4 combined
        c_math.Matrix4 projection
        c_math.Matrix4 view
        c_math.Vector3 direction
        c_math.Vector3 position
        c_math.Vector3 up
        float field_of_view
        float near
        float far
        float viewport_width
        float viewport_height

        cCamera(float viewport_width, float viewport_height)

        void look_at(const c_math.Vector3& target)
        void move(const c_math.Vector3& displacement)
        void rotate(const c_math.Vector3& axis, float angle)
        void update()


cdef class Camera:
    cdef cCamera* c