#include <iostream>
#include "ecs/entity_manager.h"
#include "matrix4.h"


int main() {
    EntityManager* em = new EntityManager();

    Matrix4 m = Matrix4::identity();

    delete em;

    return 0;
}