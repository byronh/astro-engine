#include "camera.h"


Camera::Camera() : projection(math::identity_matrix), view(math::identity_matrix) {

}

Camera::Camera(const Matrix4& projection, const Matrix4& view) : projection(projection), view(view) {

}

Camera::~Camera() {

}

const Matrix4& Camera::get_projection_matrix() const {
    return this->projection;
}

const Matrix4& Camera::get_view_matrix() const {
    return this->view;
}