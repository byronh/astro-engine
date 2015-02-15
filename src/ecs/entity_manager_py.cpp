#include "entity_manager.h"
#include <Python.h>


static void del_EntityManager(PyObject* obj) {
    EntityManager* em = (EntityManager*) PyCapsule_GetPointer(obj, "EntityManager");
    delete em;
}

static EntityManager* PyEntityManager_as_EntityManager(PyObject* obj) {
    return (EntityManager*) PyCapsule_GetPointer(obj, "EntityManager");
}

static PyObject* PyEntityManager_from_EntityManager(EntityManager* em, int must_free) {
    return PyCapsule_New(em, "EntityManager", must_free ? (PyCapsule_Destructor) del_EntityManager : NULL);
}

static PyObject* py_EntityManager(PyObject* self, PyObject* args) {
    EntityManager* em = new EntityManager();
    return PyEntityManager_from_EntityManager(em, 1);
}

static PyObject* py_entity_manager_create(PyObject* self, PyObject* py_entity_manager) {
    EntityManager* entity_manager;
    unsigned entity_id;

    entity_manager = PyEntityManager_as_EntityManager(py_entity_manager);
    if (!entity_manager) {
        return NULL;
    }
    entity_id = entity_manager->create();
    return Py_BuildValue("k", entity_id);
}

static PyObject* py_entity_manager_exists(PyObject* self, PyObject* args) {
    EntityManager* entity_manager;
    PyObject* py_entity_manager;
    unsigned long py_entity_id;

    if (!PyArg_ParseTuple(args, "Ok", &py_entity_manager, &py_entity_id)) {
        return NULL;
    }

    entity_manager = PyEntityManager_as_EntityManager(py_entity_manager);
    if (!entity_manager) {
        return NULL;
    }

    if (py_entity_id > UINT_MAX) {
        PyErr_SetString(PyExc_OverflowError, "Invalid Entity ID");
        return NULL;
    }

    bool result = entity_manager->exists((unsigned)py_entity_id);
    if (result) {
        Py_RETURN_TRUE;
    }
    Py_RETURN_FALSE;
}

static PyObject* py_entity_manager_destroy(PyObject* self, PyObject* args) {
    EntityManager* entity_manager;
    PyObject* py_entity_manager;
    unsigned long py_entity_id;

    if (!PyArg_ParseTuple(args, "Ok", &py_entity_manager, &py_entity_id)) {
        return NULL;
    }

    entity_manager = PyEntityManager_as_EntityManager(py_entity_manager);
    if (!entity_manager) {
        return NULL;
    }

    if (py_entity_id > UINT_MAX) {
        PyErr_SetString(PyExc_OverflowError, "Invalid Entity ID");
        return NULL;
    }

    entity_manager->destroy((unsigned)py_entity_id);
    Py_RETURN_NONE;
}


static PyMethodDef ecs_methods[] = {
        {"EntityManager", py_EntityManager, METH_NOARGS, NULL},
        {"entity_manager_create", py_entity_manager_create, METH_O, NULL},
        {"entity_manager_destroy", py_entity_manager_destroy, METH_VARARGS, NULL},
        {"entity_manager_exists", py_entity_manager_exists, METH_VARARGS, NULL},
        {NULL, NULL, 0, NULL}
};

static struct PyModuleDef ecs_module = {
        PyModuleDef_HEAD_INIT,
        "ecs",
        NULL,
        -1,
        ecs_methods
};

PyMODINIT_FUNC PyInit_ecs(void) {
    return PyModule_Create(&ecs_module);
}