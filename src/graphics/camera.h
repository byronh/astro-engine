#pragma once

#include "math.h"


class Camera {
public:
    Camera();
    Camera(const Matrix4& projection, const Matrix4& view);
    ~Camera() {};

    Matrix4 projection;
    Matrix4 view;
};