#include "camera.h"


Camera::Camera() : projection(Matrix4::identity()), view(Matrix4::identity()) {

}

Camera::Camera(const Matrix4& projection, const Matrix4& view) : projection(projection), view(view) {

}

Camera::~Camera() {

}

const Matrix4& Camera::get_projection_matrix() const {
    return projection;
}

const Matrix4& Camera::get_view_matrix() const {
    return view;
}