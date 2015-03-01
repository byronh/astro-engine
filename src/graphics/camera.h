#pragma once

#include "core/math.h"
#include "core/types.h"


class Camera {
public:
    Matrix4 combined;
    Matrix4 projection;
    Matrix4 view;

    Vector3 direction;
    Vector3 position;
    Vector3 up;

    float field_of_view = 45.0f;
    float near = 0.1f;
    float far = 1000.0f;
    float viewport_width;
    float viewport_height;

    explicit Camera(float viewport_width, float viewport_height);
    ~Camera() {}

    void look_at(const Vector3& target);
    void move(const Vector3& displacement);
    void rotate(const Vector3& axis, float angle);
    void update();

private:
    void normalize_up();
};