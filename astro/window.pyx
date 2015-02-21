cimport cwindow


cdef class Window:
    cdef object config
    cdef cwindow.Window* window

    def __dealloc__(self):
        cwindow.destroy(self.window)

    def __init__(self, config):
        self.config = config
        self.window = NULL

    def create(self):
        cdef bytes c_title = self.config.title.encode()
        cwindow.initialize()

        cwindow.hint(cwindow.OPENGL_PROFILE, cwindow.OPENGL_CORE_PROFILE)
        cwindow.hint(cwindow.OPENGL_FORWARD_COMPAT, True)
        cwindow.hint(cwindow.CONTEXT_VERSION_MAJOR, 3)
        cwindow.hint(cwindow.CONTEXT_VERSION_MINOR, 3)
        cwindow.hint(cwindow.FLOATING, True)
        cwindow.hint(cwindow.RESIZABLE, False)
        if self.config.samples > 0:
            cwindow.hint(cwindow.SAMPLES, self.config.samples)

        self.window = cwindow.create(self.config.width, self.config.height, c_title, NULL, NULL)
        cwindow.make_context_current(self.window)
        cwindow.swap_interval(1)

    def poll_events(self):
        cwindow.poll_events()

    def swap_buffers(self):
        cwindow.swap_buffers(self.window)


cdef object error_callback
cdef void on_error(int error_code, const char* description):
    error_callback(description)

cdef object frame_buffer_callback
cdef void on_frame_buffer_resize(cwindow.Window* window, int width, int height):
    frame_buffer_callback(width, height)

cdef object key_callback
cdef void on_key_event(cwindow.Window* window, int key, int scancode, int action, int mods):
    key_callback(key, action)

def set_error_callback(Window window, callback):
    global error_callback
    error_callback = callback
    cwindow.set_error_callback(on_error)

def set_frame_buffer_callback(Window window, callback):
    global frame_buffer_callback
    frame_buffer_callback = callback
    cwindow.set_resize_callback(window.window, on_frame_buffer_resize)

def set_key_callback(Window window, callback):
    global key_callback
    key_callback = callback
    cwindow.set_key_callback(window.window, on_key_event)