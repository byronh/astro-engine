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

        self.window = cwindow.glfwCreateWindow(self.config.width, self.config.height, c_title, NULL, NULL)
        cwindow.glfwMakeContextCurrent(<cwindow.GLFWwindow*>self.window)
        cwindow.glfwSwapInterval(1)

    def poll_events(self):
        cwindow.glfwPollEvents()

    def swap_buffers(self):
        cwindow.glfwSwapBuffers(self.window)