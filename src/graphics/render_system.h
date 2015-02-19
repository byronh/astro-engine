#pragma once

#include "camera.h"
#include "types.h"


class RenderSystem {
public:
    RenderSystem() {}
    ~RenderSystem();
    void initialize();
    void render();

    Camera* camera;

    unsigned vertexArray;
    unsigned positionAttributeBuffer;
    unsigned colorAttributeBuffer;
    unsigned mvpAttributeBuffer;

    Matrix4 mvps[10000];
};