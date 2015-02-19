#include "window/window.h"
#include <Python.h>


static PyObject* py_framebuffer_size_callback_func;
static PyObject* py_key_callback_func;


static PyObject* py_window_create(PyObject* self, PyObject* args) {
    char* title;
    int width, height, samples;
    if (!PyArg_ParseTuple(args, "siii", &title, &width, &height, &samples)) {
        return NULL;
    }
    window_create(title, width, height, samples);
    Py_RETURN_NONE;
}

static PyObject* py_window_destroy(PyObject* self, PyObject* args) {
    window_destroy();
    Py_RETURN_NONE;
}

static PyObject* py_window_poll_events(PyObject* self, PyObject* args) {
    window_poll_events();
    Py_RETURN_NONE;
}

static PyObject* py_window_swap_buffers(PyObject* self, PyObject* args) {
    window_swap_buffers();
    Py_RETURN_NONE;
}

static void py_framebuffer_size_callback(int width, int height) {
    PyObject* args;
    PyObject* kwargs;

    PyGILState_STATE state = PyGILState_Ensure();

    if (!PyCallable_Check(py_framebuffer_size_callback_func)) {
        fprintf(stderr, "framebuffer_size_callback: expected a callable\n");
        exit(EXIT_FAILURE);
    }

    args = Py_BuildValue("(ii)", width, height);
    kwargs = NULL;

    PyObject_Call(py_framebuffer_size_callback_func, args, kwargs);
    Py_DECREF(args);
    Py_XDECREF(kwargs);

    if (PyErr_Occurred()) {
        PyErr_Print();
        exit(EXIT_FAILURE);
    }

    PyGILState_Release(state);
}

static void py_key_callback(int key, int action) {
    PyObject* args;
    PyObject* kwargs;

    PyGILState_STATE state = PyGILState_Ensure();

    if (!PyCallable_Check(py_key_callback_func)) {
        fprintf(stderr, "key_callback: expected a callable\n");
        exit(EXIT_FAILURE);
    }

    args = Py_BuildValue("(ii)", key, action);
    kwargs = NULL;

    PyObject_Call(py_key_callback_func, args, kwargs);
    Py_DECREF(args);
    Py_XDECREF(kwargs);

    if (PyErr_Occurred()) {
        PyErr_Print();
        exit(EXIT_FAILURE);
    }

    PyGILState_Release(state);
}

static PyObject* py_set_framebuffer_size_callback(PyObject* self, PyObject* callback) {
    if (!PyCallable_Check(callback)) {
        return NULL;
    }

    Py_XINCREF(callback);
    Py_XDECREF(py_framebuffer_size_callback_func);

    py_framebuffer_size_callback_func = callback;
    window_set_framebuffer_size_callback(py_framebuffer_size_callback);

    Py_RETURN_NONE;
}

static PyObject* py_set_key_callback(PyObject* self, PyObject* callback) {
    if (!PyCallable_Check(callback)) {
        return NULL;
    }

    Py_XINCREF(callback);
    Py_XDECREF(py_key_callback_func);

    py_key_callback_func = callback;
    window_set_key_callback(py_key_callback);

    Py_RETURN_NONE;
}


static PyMethodDef window_methods[] = {
        {"create", py_window_create, METH_VARARGS, NULL},
        {"destroy", py_window_destroy, METH_NOARGS, NULL},
        {"poll_events", py_window_poll_events, METH_NOARGS, NULL},
        {"swap_buffers", py_window_swap_buffers, METH_NOARGS, NULL},
        {"set_framebuffer_size_callback", py_set_framebuffer_size_callback, METH_O, NULL},
        {"set_key_callback", py_set_key_callback, METH_O, NULL},
        {NULL, NULL, 0, NULL}
};

static struct PyModuleDef window_module = {
        PyModuleDef_HEAD_INIT,
        "window",
        NULL,
        -1,
        window_methods
};

PyMODINIT_FUNC PyInit_window(void) {
    return PyModule_Create(&window_module);
}