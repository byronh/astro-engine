#pragma once

#include "camera.h"
#include "math.h"


class RenderSystem {
public:
    RenderSystem() {}
    ~RenderSystem();
    void initialize();
    void render();

    Camera* camera;

    Matrix4 model;
    Matrix4 mvp;

    unsigned mvp_uniform;

    unsigned vao;
    unsigned vbo, cbo;
    unsigned ibo;
};