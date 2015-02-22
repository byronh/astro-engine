from vector cimport Vector3


cdef class Matrix4:

    def __init__(self, Vector3 position=None):
        if position:
            self.m = c_math.translate(self.m, position.v)

    def __repr__(self):
        return c_math.to_string(self.m).decode('utf-8')

    @staticmethod
    def look_at(Vector3 eye, Vector3 center, Vector3 up):
        cdef Matrix4 mat = Matrix4()
        mat.m = c_math.look_at(eye.v, center.v, up.v)
        return mat

    @staticmethod
    def perspective(float field_of_view, float aspect, float near, float far):
        cdef Matrix4 mat = Matrix4()
        mat.m = c_math.perspective(field_of_view, aspect, near, far)
        return mat

    @staticmethod
    def translate(Matrix4 matrix, Vector3 vec):
        cdef Matrix4 mat = Matrix4()
        mat.m = c_math.translate(matrix.m, vec.v)
        return mat