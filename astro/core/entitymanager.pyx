cimport c_core


cdef class EntityManager:
    cdef c_core.EntityManager* this_ptr

    def __cinit__(self):
        self.this_ptr = new c_core.EntityManager()

    def __dealloc__(self):
        del self.this_ptr

    def create(self):
        return self.this_ptr.create()

    def destroy(self, unsigned int entity_id):
        self.this_ptr.destroy(entity_id)

    def exists(self, unsigned int entity_id):
        return self.this_ptr.exists(entity_id)