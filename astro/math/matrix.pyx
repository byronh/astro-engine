from vector cimport Vector3


cdef class Matrix4:

    def __repr__(self):
        return c_math.to_string(self.m).decode('utf-8')

    @staticmethod
    def look_at(Vector3 eye, Vector3 center, Vector3 up):
        mat = Matrix4()
        mat.m = c_math.look_at(eye.v, center.v, up.v)
        return mat

    @staticmethod
    def perspective(float fov, float aspect, float near, float far):
        mat = Matrix4()
        mat.m = c_math.perspective(fov, aspect, near, far)
        return mat