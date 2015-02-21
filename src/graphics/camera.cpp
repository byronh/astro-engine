#include "graphics/camera.h"


Camera::Camera() : projection(Matrix4()), view(Matrix4()) {

}

Camera::Camera(const Matrix4& projection, const Matrix4& view) :
        projection(projection), view(view) {
}