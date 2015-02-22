#include "graphics/renderer.h"
#include "graphics/gl.h"


void Renderer::initialize() {

    // TODO move these somewhere else
    gl::initialize();
    gl::set_clear_color(Color{0.1, 0.1, 0.1, 1.0});

    // TODO make resizable
    unsigned int size = Renderer::max_instances;
    size_t bytes_per_instance = sizeof(unsigned int) + sizeof(unsigned int) + sizeof(Matrix4);

    // TODO use custom allocators
    this->data.num_instances = 0;
    this->data.buffer = malloc(bytes_per_instance * size);
    this->data.entity_ids = (unsigned int*)(this->data.buffer);
    this->data.model_ids = (unsigned int*)(this->data.entity_ids + size);
    this->data.transforms = (Matrix4*)(this->data.model_ids + size);

    // TODO make AssetManager class to manage lifetime
    this->models[0] = new Model();
}

void Renderer::add_component(unsigned int entity_id, unsigned int model_id, Matrix4 transform) {
    assert(this->data.num_instances < Renderer::max_instances);
    unsigned int index = this->data.num_instances;
    this->data.entity_ids[index] = entity_id;
    this->data.model_ids[index] = model_id;
    this->data.transforms[index] = transform;
    this->data.num_instances++;
}

void Renderer::render(Camera* camera) {
    gl::clear();

    // TODO move to camera class
    Matrix4 combined = camera->projection * camera->view;
    gl::set_uniform_matrix(0, combined);

    for (auto item: this->models) {
        Model* model = item.second;
        model->render(this->data.transforms, this->data.num_instances);
    }
}

void Renderer::shutdown() {
    delete this->models[0];
    free(this->data.buffer);
}
