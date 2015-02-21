# distutils: language = c++
# distutils: sources = src/core/entity_manager.cpp

cimport centity_manager


cdef class EntityManager:
    cdef centity_manager.EntityManager* this_ptr

    def __cinit__(self):
        self.this_ptr = new centity_manager.EntityManager()

    def __dealloc__(self):
        del self.this_ptr

    def create(self) -> int:
        return self.this_ptr.create()

    def destroy(self, unsigned int entity_id):
        self.this_ptr.destroy(entity_id)

    def exists(self, unsigned int entity_id) -> bool:
        return self.this_ptr.exists(entity_id)