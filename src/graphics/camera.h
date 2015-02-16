#pragma once

#include "matrix4.h"


class Camera {
public:
    Camera();
    Camera(const Matrix4& projection, const Matrix4& view);
    virtual ~Camera();

    const Matrix4& get_projection_matrix() const;
    const Matrix4& get_view_matrix() const;

private:
    Matrix4 projection;
    Matrix4 view;
};