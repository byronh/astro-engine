#include "gl.h"
#include <stdio.h>
#include <GL/glew.h>
#include <Python.h>


void gl_initialize(void) {
    glewExperimental = GL_TRUE;
    GLenum error = glewInit();
    if (error != GLEW_OK) {
        fprintf(stderr, "Failed to initialize glew");
        exit(EXIT_FAILURE);
    }

    printf("\n");
    printf("OpenGL version: %s\n", glGetString(GL_VERSION));
    printf("GLSL version: %s\n", glGetString(GL_SHADING_LANGUAGE_VERSION));
    printf("Vendor: %s\n", glGetString(GL_VENDOR));
    printf("Renderer: %s\n", glGetString(GL_RENDERER));
    printf("\n");

    glClearColor(0.0, 0.0, 0.0, 1.0);
    glClearDepth(1.0);
}

void gl_set_clear_color(Color c) {

}

void gl_clear(void) {
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
}

static PyObject* py_gl_initialize(PyObject* self, PyObject* args) {
    gl_initialize();
    Py_RETURN_NONE;
}

static PyObject* py_gl_clear(PyObject* self, PyObject* args) {
    gl_clear();
    Py_RETURN_NONE;
}


static PyMethodDef gl_methods[] = {
        {"initialize", py_gl_initialize, METH_NOARGS, "Initialize"},
        {"clear", py_gl_clear, METH_NOARGS, "Clear"},
        {NULL, NULL, 0, NULL}
};

static struct PyModuleDef gl_module = {
        PyModuleDef_HEAD_INIT,
        "gl",
        NULL,
        -1,
        gl_methods
};

PyMODINIT_FUNC PyInit_gl(void) {
    return PyModule_Create(&gl_module);
}