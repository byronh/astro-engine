#include <Python.h>


// For C++ debugging in your IDE of choice
int main() {
    Py_Initialize();
    PyRun_SimpleString("import sys; sys.path.append('.')");

    PyObject* module = PyImport_ImportModule("main");
    if (!module) {
        PyErr_Print();
        Py_Finalize();
        return -1;
    }
    PyObject* main_func = PyObject_GetAttrString(module, "main");
    if (!PyCallable_Check(main_func)) {
        PyErr_Print();
        Py_Finalize();
        return -1;
    }
    PyObject_CallObject(main_func, NULL);
    Py_Finalize();

    return 0;
}