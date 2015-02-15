#pragma once

#include "ecs/entity_manager.h"


class Entity {
    friend class EntityManager;

public:
    static const unsigned int index_bits = 24;
    static const unsigned int index_mask = (1 << index_bits) - 1;
    static const unsigned int generation_bits = 8;
    static const unsigned int generation_mask = (1 << generation_bits) - 1;

    const unsigned int id;
    Entity(unsigned int id): id(id) {}
    unsigned int get_index() const {
        return id & index_mask;
    }
    unsigned int get_generation() const {
        return (id >> index_bits) & generation_mask;
    }

private:
    Entity(unsigned int index, unsigned int generation) :
            id(index | (generation << index_bits)) {
    }
};