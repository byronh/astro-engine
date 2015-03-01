cdef extern from "core/entitymanager.h":

    cppclass cEntityManager "EntityManager":
        cEntityManager()
        unsigned int create()
        void destroy(unsigned int entity_id)
        bint exists(unsigned int entity_id) const


cdef class EntityManager:
    cdef cEntityManager em