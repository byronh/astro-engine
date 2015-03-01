#include "graphics/camera.h"
#include <glm/gtc/matrix_transform.hpp>
#include <glm/gtx/string_cast.hpp>
#include <glm/gtx/rotate_vector.hpp>


Camera::Camera(float viewport_width, float viewport_height) :
        direction(Vector3(0, 0, -1)),
        up(Vector3(0, 1, 0)),
        viewport_width(viewport_width),
        viewport_height(viewport_height) {
}

void Camera::look_at(const Vector3 &target) {
    Vector3 temp = glm::normalize(target - this->position);
    if (!(temp.x == 0 && temp.y == 0 && temp.z == 0)) {
        this->direction = temp;
        this->normalize_up();
    }
}

void Camera::move(const Vector3 &displacement) {
    this->position += displacement;
}

void Camera::rotate(const Vector3 &axis, float angle) {
    angle = glm::radians(angle);
    this->direction = glm::rotate(this->direction, angle, axis);
    this->up = glm::rotate(this->up, angle, axis);
}


void Camera::update() {
    float aspect = this->viewport_width / this->viewport_height;
    this->projection = glm::perspective(this->field_of_view, aspect, this->near, this->far);
    this->view = glm::lookAt(this->position, this->position + this->direction, this->up);
    this->combined = this->projection * this->view;
}

void Camera::normalize_up() {
    Vector3 right = glm::normalize(glm::cross(this->direction, this->up));
    this->up = glm::normalize(glm::cross(right, this->direction));
}

