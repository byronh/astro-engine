cimport cwindow


cdef class Window:
    cdef object config
    cdef cwindow.GLFWwindow* window

    def __dealloc__(self):
        cwindow.glfwDestroyWindow(<cwindow.GLFWwindow*>self.window)

    def __init__(self, config):
        self.config = config
        self.window = NULL

    def create(self):
        cdef bytes c_title = self.config.title.encode()
        cwindow.glfwInit()

        cwindow.glfwWindowHint(cwindow.GLFW_OPENGL_PROFILE, cwindow.GLFW_OPENGL_CORE_PROFILE)
        cwindow.glfwWindowHint(cwindow.GLFW_OPENGL_FORWARD_COMPAT, True)
        cwindow.glfwWindowHint(cwindow.GLFW_CONTEXT_VERSION_MAJOR, 3)
        cwindow.glfwWindowHint(cwindow.GLFW_CONTEXT_VERSION_MINOR, 3)
        cwindow.glfwWindowHint(cwindow.GLFW_FLOATING, True)
        cwindow.glfwWindowHint(cwindow.GLFW_RESIZABLE, False)
        if self.config.samples > 0:
            cwindow.glfwWindowHint(cwindow.GLFW_SAMPLES, self.config.samples)

        self.window = cwindow.glfwCreateWindow(self.config.width, self.config.height, c_title, NULL, NULL)
        cwindow.glfwMakeContextCurrent(<cwindow.GLFWwindow*>self.window)
        cwindow.glfwSwapInterval(1)

    def poll_events(self):
        cwindow.glfwPollEvents()

    def swap_buffers(self):
        cwindow.glfwSwapBuffers(self.window)


cdef object error_callback
cdef void on_error(int error_code, const char* description):
    error_callback(description)

cdef object frame_buffer_callback
cdef void on_frame_buffer_resize(cwindow.GLFWwindow* window, int width, int height):
    frame_buffer_callback(width, height)

cdef object key_callback;
cdef void on_key_event(cwindow.GLFWwindow* window, int key, int scancode, int action, int mods):
    key_callback(key, action)

def set_error_callback(Window window, callback):
    global error_callback
    error_callback = callback
    cwindow.glfwSetErrorCallback(on_error)

def set_frame_buffer_callback(Window window, callback):
    global frame_buffer_callback
    frame_buffer_callback = callback
    cwindow.glfwSetFramebufferSizeCallback(<cwindow.GLFWwindow*>window.window, on_frame_buffer_resize)

def set_key_callback(Window window, callback):
    global key_callback
    key_callback = callback
    cwindow.glfwSetKeyCallback(<cwindow.GLFWwindow*>window.window, on_key_event)