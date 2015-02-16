#include "render_system.h"
#include "gl.h"


void RenderSystem::initialize() {
    gl::initialize();
    gl::set_clear_color(Color{0.0, 0.0, 0.0, 1.0});
}

void RenderSystem::render() {
    gl::clear();
}