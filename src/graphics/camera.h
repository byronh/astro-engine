#pragma once

#include "core/math.h"


class Camera {
public:
    Camera();
    ~Camera() {}

    Matrix4 projection;
    Matrix4 view;

    Vector3 direction;
    Vector3 position;
    Vector3 up;

    void look_at(const Vector3& target);
    void move(const Vector3& displacement);
    void rotate(const Vector3& axis, float angle);
    void update();

private:
    void normalize_up();
};