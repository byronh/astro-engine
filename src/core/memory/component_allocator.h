#pragma once

#include "allocator.h"


class ComponentAllocator: public Allocator {

protected:
    virtual void* allocate(size_t size);
    virtual void deallocate(void* p);
};