#include "render_system.h"
#include "gl.h"
#include <iostream>


void RenderSystem::initialize() {
    gl_initialize();
    gl_set_clear_color(Color{0.0, 0.0, 0.0, 1.0});
}

void RenderSystem::update(float delta_time) {
    gl_clear();
}