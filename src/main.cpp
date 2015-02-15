#include "memory/component_allocator.h"
#include <iostream>


class Test {
    int x;
    int y;
    int z;
};


int main() {
    Test t;
    std::cout << sizeof(Test) << std::endl;
    std::cout << alignof(Test) << std::endl;

    ComponentAllocator ca;

    return 0;
}