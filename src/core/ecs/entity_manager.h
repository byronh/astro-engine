#pragma once

#include "ecs/entity.h"
#include <deque>
#include <vector>


class EntityManager {
public:
    Entity create();
    bool active(Entity e) const;
    void destroy(Entity e);

private:
    std::vector<unsigned char> generations;
    std::deque<unsigned int> free_indices;
};