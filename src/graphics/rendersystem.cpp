#include "rendersystem.h"
#include "graphics/gl.h"


RenderSystem::~RenderSystem() {

}

void RenderSystem::initialize() {
    gl::initialize();
    gl::set_clear_color(Color{0.1, 0.1, 0.1, 1.0});

    r.initialize();
}

void RenderSystem::render() {
    gl::clear();
    r.render(this->camera);
}