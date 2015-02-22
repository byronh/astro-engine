from libcpp.string cimport string


cdef extern from "core/math.h":

    cppclass Matrix4:
        Matrix4()
        Matrix4 operator *(const Matrix4& mat)

    cppclass Vector3:
        float x, y, z
        Vector3()
        Vector3(float x, float y, float z)


cdef extern from "<glm/gtx/string_cast.hpp>" namespace "glm":

    string to_string(const Matrix4& mat)
    string to_string(const Vector3& vec)


cdef extern from "<glm/gtc/matrix_transform.hpp>" namespace "glm":

    Matrix4 look_at "lookAt" (const Vector3& eye, const Vector3& center, const Vector3& up)
    Matrix4 perspective(float fov, float aspect, float near, float far)
    Matrix4 translate(const Matrix4& mat, const Vector3& vec)