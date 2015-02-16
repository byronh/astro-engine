#pragma once

#include <math.h>


struct Vector3 {
    float x;
    float y;
    float z;

    Vector3() {}
    Vector3(float x, float y, float z) : x(x), y(y), z(z) {}

    Vector3 operator+(const Vector3& other) const;
    Vector3 operator-(const Vector3& other) const;
    Vector3 operator-() const;

    float length() const;
    void normalize();
};

inline Vector3 Vector3::operator+(const Vector3& other) const {
    return Vector3(x + other.x, y + other.y, z + other.z);
}

inline Vector3 Vector3::operator-(const Vector3& other) const {
    return Vector3(x - other.x, y - other.y, z - other.z);
}

inline Vector3 Vector3::operator-() const {
    return Vector3(-x, -y, -z);
}

inline float Vector3::length() const {
    return sqrtf(x * x + y * y + z * z);
}

inline void Vector3::normalize() {
    float length = this->length();
    if (length == 0) length = 1;
    float ilength = 1.0f / length;
    x *= ilength;
    y *= ilength;
    z *= ilength;
}

namespace vector3 {
    inline Vector3 cross_product(const Vector3& vec1, const Vector3& vec2) {
        return Vector3(
                vec1.y * vec2.z - vec1.z * vec2.y,
                vec1.z * vec2.x - vec1.x * vec2.z,
                vec1.x * vec2.y - vec1.y * vec2.x);
    }

    inline float dot(const Vector3& vec1, const Vector3& vec2) {
        return vec1.x * vec2.x + vec1.y * vec2.y + vec1.z * vec2.z;
    }
}