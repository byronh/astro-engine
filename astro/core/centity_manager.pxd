cdef extern from "core/entity_manager.h":

    cppclass EntityManager:
        EntityManager()
        unsigned int create()
        void destroy(unsigned int entity_id)
        bint exists(unsigned int entity_id) const