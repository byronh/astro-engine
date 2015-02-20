cdef extern from "GLFW/glfw3.h":
    cdef int GLFW_OPENGL_PROFILE
    cdef int GLFW_OPENGL_CORE_PROFILE
    cdef int GLFW_OPENGL_FORWARD_COMPAT
    cdef int GLFW_CONTEXT_VERSION_MAJOR
    cdef int GLFW_CONTEXT_VERSION_MINOR
    cdef int GLFW_FLOATING
    cdef int GLFW_RESIZABLE

    cdef struct GLFWmonitor:
        pass

    cdef struct GLFWwindow:
        pass

    int glfwInit()
    GLFWwindow* glfwCreateWindow(int width, int height, const char* title, GLFWmonitor* monitor, GLFWwindow* share)
    void glfwDestroyWindow(GLFWwindow* window)
    void glfwWindowHint(int target, int hint)
    void glfwMakeContextCurrent(GLFWwindow* window)
    void glfwPollEvents()
    void glfwSwapBuffers(GLFWwindow* window)
    void glfwSwapInterval(int interval)