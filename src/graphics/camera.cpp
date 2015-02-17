#include "camera.h"


Camera::Camera() : projection(glm::mat4x4(1.0f)), view(glm::mat4x4(1.0f)) {

}

Camera::Camera(const Matrix4& projection, const Matrix4& view) :
        projection(projection), view(view) {
}