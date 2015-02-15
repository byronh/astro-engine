#include "allocator.h"

template<class T, class P>
T* Allocator::create(P const &p1) {
    return new (allocate(sizeof(T))) T(p1);
}

template<class T>
void Allocator::destroy(T * p) {
    if (p) {
        p->~T();
        deallocate(p);
    }
}

