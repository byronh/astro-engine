cimport c_window


cdef class Window:
    cdef object config
    cdef c_window.Window* window

    def __dealloc__(self):
        c_window.destroy(self.window)

    def __init__(self, config):
        self.config = config
        self.window = NULL

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

    def swap_buffers(self):
        c_window.swap_buffers(self.window)


cdef object error_callback
cdef void on_error(int error_code, const char* description):
    error_callback(description)

cdef object frame_buffer_callback
cdef void on_frame_buffer_resize(c_window.Window* window, int width, int height):
    frame_buffer_callback(width, height)

cdef object key_callback
cdef void on_key_event(c_window.Window* window, int key, int scancode, int action, int mods):
    key_callback(key, action)

def set_error_callback(Window window, callback):
    global error_callback
    error_callback = callback
    c_window.set_error_callback(on_error)

def set_frame_buffer_callback(Window window, callback):
    global frame_buffer_callback
    frame_buffer_callback = callback
    c_window.set_resize_callback(window.window, on_frame_buffer_resize)

def set_key_callback(Window window, callback):
    global key_callback
    key_callback = callback
    c_window.set_key_callback(window.window, on_key_event)