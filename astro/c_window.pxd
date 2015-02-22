cdef extern from "GLFW/glfw3.h":
    cdef int CONTEXT_VERSION_MAJOR "GLFW_CONTEXT_VERSION_MAJOR"
    cdef int CONTEXT_VERSION_MINOR "GLFW_CONTEXT_VERSION_MINOR"
    cdef int FLOATING "GLFW_FLOATING"
    cdef int OPENGL_CORE_PROFILE "GLFW_OPENGL_CORE_PROFILE"
    cdef int OPENGL_FORWARD_COMPAT "GLFW_OPENGL_FORWARD_COMPAT"
    cdef int OPENGL_PROFILE "GLFW_OPENGL_PROFILE"
    cdef int RESIZABLE "GLFW_RESIZABLE"
    cdef int SAMPLES "GLFW_SAMPLES"

    cdef struct Monitor "GLFWmonitor":
        pass

    cdef struct Window "GLFWwindow":
        pass

    ctypedef void (*GLFWcursorposfun)(Window*, double, double)
    ctypedef void (*GLFWerrorfun)(int, const char*)
    ctypedef void (*GLFWframebuffersizefun)(Window*, int, int)
    ctypedef void (*GLFWkeyfun)(Window*, int, int, int, int)
    ctypedef void (*GLFWmousebuttonfun)(Window*,int, int, int)
    ctypedef void (*GLFWscrollfun)(Window*, double, double)

    bint initialize "glfwInit" ()
    void close "glfwSetWindowShouldClose" (Window* window, bint value)
    Window* create "glfwCreateWindow" (int width, int height, const char* title, Monitor* monitor, Window* share)
    void destroy "glfwDestroyWindow" (Window* window)
    void hint "glfwWindowHint" (int target, int hint)
    void make_context_current "glfwMakeContextCurrent" (Window* window)
    void poll_events "glfwPollEvents" ()
    bint should_close "glfwWindowShouldClose" (Window* window)
    void swap_buffers "glfwSwapBuffers" (Window* window)
    void swap_interval "glfwSwapInterval" (int interval)
    void terminate "glfwTerminate" ()

    GLFWerrorfun set_error_callback "glfwSetErrorCallback" (GLFWerrorfun cbfun)
    GLFWkeyfun set_key_callback "glfwSetKeyCallback" (Window* window, GLFWkeyfun cbfun)
    GLFWmousebuttonfun set_mouse_button_callback "glfwSetMouseButtonCallback" (Window* window, GLFWmousebuttonfun cbfun)
    GLFWcursorposfun set_mouse_move_callback "glfwSetCursorPosCallback" (Window* window, GLFWcursorposfun cbfun)
    GLFWframebuffersizefun set_resize_callback "glfwSetFramebufferSizeCallback" (Window* window,
                                                                                 GLFWframebuffersizefun cbfun)
    GLFWscrollfun set_scroll_callback "glfwSetScrollCallback" (Window* window, GLFWscrollfun cbfun)