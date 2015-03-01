# distutils: sources = src/core/entitymanager.cpp


cdef class EntityManager:
    def create(self):
        return self.em.create()

    def destroy(self, unsigned int entity_id):
        self.em.destroy(entity_id)

    def exists(self, unsigned int entity_id):
        return self.em.exists(entity_id)