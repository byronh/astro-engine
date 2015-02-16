#pragma once

#include "vector3.h"


struct Matrix4 {
    float m0, m4, m8, m12;
    float m1, m5, m9, m13;
    float m2, m6, m10, m14;
    float m3, m7, m11, m15;

    static Matrix4 frustum(float left, float right, float bottom, float top, float near, float far) {
        Matrix4 result;

        float rl = (right - left);
        float tb = (top - bottom);
        float fn = (far - near);

        result.m0 = (near * 2.0f) / rl;
        result.m1 = 0;
        result.m2 = 0;
        result.m3 = 0;

        result.m4 = 0;
        result.m5 = (near * 2.0f) / tb;
        result.m6 = 0;
        result.m7 = 0;

        result.m8 = (right + left) / rl;
        result.m9 = (top + bottom) / tb;
        result.m10 = -(far + near) / fn;
        result.m11 = -1.0f;

        result.m12 = 0;
        result.m13 = 0;
        result.m14 = -(far * near * 2.0f) / fn;
        result.m15 = 0;

        return result;
    }

    static Matrix4 look_at(Vector3 eye, Vector3 center, Vector3 up) {
        Matrix4 result;

        Vector3 z = eye - center;
        z.normalize();
        Vector3 x = vector3::cross_product(up, z);
        x.normalize();
        Vector3 y = vector3::cross_product(z, x);
        y.normalize();

        result.m0 = x.x;
        result.m1 = x.y;
        result.m2 = x.z;
        result.m3 = -((x.x * eye.x) + (x.y * eye.y) + (x.z * eye.z));
        result.m4 = y.x;
        result.m5 = y.y;
        result.m6 = y.z;
        result.m7 = -((y.x * eye.x) + (y.y * eye.y) + (y.z * eye.z));
        result.m8 = z.x;
        result.m9 = z.y;
        result.m10 = z.z;
        result.m11 = -((z.x * eye.x) + (z.y * eye.y) + (z.z * eye.z));
        result.m12 = 0;
        result.m13 = 0;
        result.m14 = 0;
        result.m15 = 1;

        return result;
    }

    static Matrix4 perspective(float fov, float aspect, float near, float far) {
        float top = near * tanf(fov * (float) M_PI / 360.0f);
        float right = top * aspect;

        return frustum(-right, right, -top, top, near, far);
    }
};

namespace math {
    static const Matrix4 identity_matrix = {1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1};
}