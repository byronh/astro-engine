#pragma once

#include "graphics/camera.h"
#include "graphics/model.h"
#include "graphics/renderer.h"
#include "core/math.h"


class RenderSystem {
public:
    RenderSystem() {}
    ~RenderSystem();
    void initialize();
    void render();

    Camera* camera;
    Renderer r;
};