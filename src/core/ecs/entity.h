#pragma once

#include "ecs/entity_manager.h"


static const unsigned int ENTITY_INDEX_BITS = 24;
static const unsigned int ENTITY_INDEX_MASK = (1 << ENTITY_INDEX_BITS) - 1;
static const unsigned int ENTITY_GENERATION_BITS = 8;
static const unsigned int ENTITY_GENERATION_MASK = (1 << ENTITY_GENERATION_BITS) - 1;


class Entity {
    friend class EntityManager;

public:
    const unsigned int id;
    Entity(unsigned int id): id(id) {}

private:
    Entity(unsigned int index, unsigned int generation) :
            id(index | (generation << ENTITY_INDEX_BITS)) {
    }
    unsigned int get_index() const {
        return id & ENTITY_INDEX_MASK;
    }
    unsigned int get_generation() const {
        return (id >> ENTITY_INDEX_BITS) & ENTITY_GENERATION_MASK;
    }
};