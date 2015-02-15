#include "ecs/entity_manager.h"
#include <assert.h>


Entity EntityManager::create() {
    unsigned int index;
    if (this->free_indices.size() > 1024) {
        index = this->free_indices.front();
        this->free_indices.pop_front();
    } else {
        this->generations.push_back(0);
        index = (unsigned int)this->generations.size() - 1;
        assert(index < (1 << ENTITY_INDEX_BITS));
    }
    return Entity(index, this->generations[index]);
}

bool EntityManager::active(Entity e) const {
    return this->generations[e.get_index()] == e.get_generation();
}

void EntityManager::destroy(Entity e) {
    const unsigned int index = e.get_index();
    this->generations[index]++;
    this->free_indices.push_back(index);
}