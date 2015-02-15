#pragma once

#include <stddef.h>


class Allocator {
public:
    template<class T, class P>
    T* create(const P &p1);

    template<class T>
    void destroy(T* p);

protected:
    virtual void *allocate(size_t size) = 0;
    virtual void deallocate(void *p) = 0;

    unsigned int count;
    size_t total_size;
};