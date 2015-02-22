#pragma once

#include "core/math.h"
#include "graphics/camera.h"
#include "graphics/model.h"
#include <unordered_map>


class Renderer {
public:
    static const unsigned int max_instances = 1024;

    void add_component(unsigned int entity_id, unsigned int model_id, Matrix4 transform);
    void initialize();
    void render(Camera* camera);
    void shutdown();

private:
    struct InstanceData {
        unsigned int num_instances;

        void* buffer;
        unsigned int* entity_ids;
        unsigned int* model_ids;
        Matrix4* transforms;
    };

    InstanceData data;
    std::unordered_map<unsigned int, Model*> models;
};