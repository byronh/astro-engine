from libcpp.string cimport string


cdef extern from "core/math.h":

    cppclass Matrix4:
        Matrix4()

    cppclass Vector3:
        float x, y, z
        Vector3()
        Vector3(float x, float y, float z)


cdef extern from "<glm/gtx/string_cast.hpp>" namespace "glm":

    string to_string(Matrix4& mat)
    string to_string(Vector3& vec)


cdef extern from "<glm/gtc/matrix_transform.hpp>" namespace "glm":

    Matrix4 look_at "lookAt" (Vector3& eye, Vector3& center, Vector3& up)
    Matrix4 perspective (float fov, float aspect, float near, float far)