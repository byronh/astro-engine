cimport c_window


cdef class Window:
    cdef object config
    cdef c_window.Window* window

    def __cinit__(self):
        self.window = NULL

    def __dealloc__(self):
        c_window.destroy(self.window)
        c_window.terminate()

    def __init__(self, config):
        self.config = config
        self.window = NULL

    def close(self):
        c_window.close(self.window, True)

    def create(self):
        cdef bytes c_title = self.config.title.encode()
        c_window.initialize()

        c_window.hint(c_window.OPENGL_PROFILE, c_window.OPENGL_CORE_PROFILE)
        c_window.hint(c_window.OPENGL_FORWARD_COMPAT, True)
        c_window.hint(c_window.CONTEXT_VERSION_MAJOR, 3)
        c_window.hint(c_window.CONTEXT_VERSION_MINOR, 3)
        c_window.hint(c_window.FLOATING, True)
        c_window.hint(c_window.RESIZABLE, False)
        if self.config.samples > 0:
            c_window.hint(c_window.SAMPLES, self.config.samples)

        self.window = c_window.create(self.config.width, self.config.height, c_title, NULL, NULL)
        c_window.make_context_current(self.window)
        c_window.swap_interval(1)

    def poll_events(self):
        c_window.poll_events()

    def should_close(self):
        return c_window.should_close(self.window)

    def swap_buffers(self):
        c_window.swap_buffers(self.window)


cdef object error_callback
cdef void on_error(int error_code, const char* description):
    error_callback(description)

cdef object key_callback
cdef void on_key_event(c_window.Window* window, int key, int scancode, int action, int mods):
    key_callback(key, action)

cdef object resize_callback
cdef void on_frame_buffer_resize(c_window.Window* window, int width, int height):
    resize_callback(width, height)

def set_error_callback(Window window, callback):
    global error_callback
    error_callback = callback
    c_window.set_error_callback(on_error)

def set_key_callback(Window window, callback):
    global key_callback
    key_callback = callback
    c_window.set_key_callback(window.window, on_key_event)

def set_resize_callback(Window window, callback):
    global resize_callback
    resize_callback = callback
    c_window.set_resize_callback(window.window, on_frame_buffer_resize)