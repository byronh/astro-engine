#pragma once

#include "entity_manager.h"
#include <deque>
#include <vector>


class EntityManager {
public:
    unsigned create();
    void destroy(unsigned id);
    bool exists(unsigned id) const;

private:
    static const unsigned index_bits = 24;
    static const unsigned index_mask = (1 << index_bits) - 1;
    static const unsigned generation_bits = 8;
    static const unsigned generation_mask = (1 << generation_bits) - 1;

    std::vector<unsigned char> generations;
    std::deque<unsigned> free_indices;

    unsigned get_index(unsigned id) const;
    unsigned get_generation(unsigned id) const;
};