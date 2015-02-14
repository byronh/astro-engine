#include "window.h"
#include <stdio.h>
#include <GLFW/glfw3.h>
#include <Python.h>


static GLFWwindow* window;

void window_create(char* title, int width, int height, int samples) {
    if (!glfwInit()) {
        fprintf(stderr, "Failed to initialize GLFW");
        exit(EXIT_FAILURE);
    }

    glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
    glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE);
    glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
    glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);

    if (samples > 0) {
        glfwWindowHint(GLFW_SAMPLES, samples);
    }

    window = glfwCreateWindow(width, height, title, NULL, NULL);
    if (!window) {
        fprintf(stderr, "Failed to create window");
        glfwTerminate();
        exit(EXIT_FAILURE);
    }
    glfwMakeContextCurrent(window);
    glfwSwapInterval(1);
}

void window_destroy(void) {
    glfwDestroyWindow(window);
    glfwTerminate();
}

void window_poll_events(void) {
    glfwPollEvents();
}

void window_swap_buffers(void) {
    glfwSwapBuffers(window);
}

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

static PyObject* py_key_callback_func;

static void key_callback(GLFWwindow* window, int key, int scancode, int action, int mods) {
    PyObject* args;
    PyObject* kwargs;

    PyGILState_STATE state = PyGILState_Ensure();

    if (!PyCallable_Check(py_key_callback_func)) {
        fprintf(stderr, "call_key_callback: expected a callable\n");
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

static PyObject* py_set_key_callback(PyObject* self, PyObject* args) {
    PyObject* temp;
    if (!PyArg_ParseTuple(args, "O", &temp)) {
        return NULL;
    }
    if (!PyCallable_Check(temp)) {
        return NULL;
    }

    Py_XINCREF(temp);
    Py_XDECREF(py_key_callback_func);

    py_key_callback_func = temp;
    glfwSetKeyCallback(window, key_callback);

    Py_RETURN_NONE;
}

static PyMethodDef window_methods[] = {
        {"create", py_window_create, METH_VARARGS, "Open a GLFW window"},
        {"destroy", py_window_destroy, METH_NOARGS, "Destroy the GLFW window"},
        {"poll_events", py_window_poll_events, METH_NOARGS, "Poll for input events"},
        {"swap_buffers", py_window_swap_buffers, METH_NOARGS, "Swap the front and back buffers"},
        {"set_key_callback", py_set_key_callback, METH_VARARGS, "Set the keypress callback function"},
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