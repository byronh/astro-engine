#include "entitymanager.h"
#include <assert.h>


unsigned EntityManager::create() {
    unsigned index;
    if (this->free_indices.size() > 1024) {
        index = this->free_indices.front();
        this->free_indices.pop_front();
    } else {
        this->generations.push_back(0);
        index = (unsigned)this->generations.size() - 1;
        assert(index < (1 << index_bits)); // Max entities exceeded
    }
    return index | (this->generations[index] << index_bits);
}

void EntityManager::destroy(unsigned id) {
    const unsigned index = this->get_index(id);
    this->generations[index]++;
    this->free_indices.push_back(index);
}

bool EntityManager::exists(unsigned id) const {
    return this->generations[this->get_index(id)] == this->get_generation(id);
}

unsigned EntityManager::get_index(unsigned id) const {
    return id & index_mask;
}

unsigned EntityManager::get_generation(unsigned id) const {
    return (id >> index_bits) & generation_mask;
}