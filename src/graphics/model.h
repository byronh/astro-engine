#pragma once

#include "core/math.h"
#include "graphics/camera.h"


class Model {
public:
    unsigned int id;

    Model();
    ~Model();

    void render(Matrix4* transforms, unsigned int count);

private:

    // TODO use bitwise attributes
    static const unsigned POSITION_LOCATION = 0;
    static const unsigned COLOR_LOCATION = 1;
    static const unsigned WORLD_LOCATION = 2;

    unsigned int attribute_buffers[3];

    Model(const Model& other);
    const Model& operator= (const Model& other);
};