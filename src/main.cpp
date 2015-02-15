#include <iostream>
#include "ecs/entity_manager.h"


int main() {
    EntityManager* em = new EntityManager();
    delete em;

    return 0;
}