#include "render_system.h"
#include "gl.h"


RenderSystem::~RenderSystem() {

}

void RenderSystem::initialize() {
    gl_initialize();
    gl_set_clear_color(Color{0.0, 0.5, 1.0, 1.0});
}

void RenderSystem::update(float delta_time) {
    gl_clear();
}