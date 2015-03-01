# distutils: libraries = SDL2

cimport platform


cdef class DesktopApplication:
    def __cinit__(self):
        self.running = False

    def __init__(self, config):
        self.config = config
        self.window = platform.Window(config.title.encode('utf-8'), config.width, config.height, config.samples)

    def exit(self):
        self.running = False

    def run(self, listener_class):
        self.application_listener = listener_class()
        self.application_listener.app = self
        self.application_listener.create()
        self.application_listener.resize(self.config.width, self.config.height)

        self.running = True

        while self.running:
            self.poll_events()

            self.application_listener.update(0)
            self.application_listener.render()
            self.window.swap_buffers()

        self.application_listener.destroy()

    def set_input_listener(self, listener):
        self.input_listener = listener

    cdef void poll_events(self):
        cdef SDL_Event event
        while SDL_PollEvent(&event):
            if self.input_listener:
                if event.type == SDL_MOUSEMOTION:
                    self.input_listener.mouse_move(event.motion.x, event.motion.y)
                elif event.type == SDL_KEYDOWN:
                    self.input_listener.key_down(event.key.keysym.sym)
                elif event.type == SDL_KEYUP:
                    self.input_listener.key_up(event.key.keysym.sym)
                elif event.type == SDL_MOUSEBUTTONDOWN:
                    self.input_listener.mouse_down(event.button.button)
                elif event.type == SDL_MOUSEBUTTONUP:
                    self.input_listener.mouse_up(event.button.button)
                elif event.type == SDL_WINDOWEVENT and event.window.event == SDL_WINDOWEVENT_SIZE_CHANGED:
                    self.application_listener.resize(event.window.data1, event.window.data2)
            if event.type == SDL_QUIT:
                self.running = False


cdef class Window:
    def __cinit__(self, char* title, int width, int height, int samples):
        SDL_Init(SDL_INIT_VIDEO)
        self.window = SDL_CreateWindow(title, 0, 0, width, height, SDL_WINDOW_OPENGL)

        SDL_GL_SetAttribute(SDL_GL_CONTEXT_MAJOR_VERSION, 3)
        SDL_GL_SetAttribute(SDL_GL_CONTEXT_MINOR_VERSION, 3)
        SDL_GL_SetAttribute(SDL_GL_CONTEXT_PROFILE_MASK, SDL_GL_CONTEXT_PROFILE_CORE)
        SDL_GL_SetAttribute(SDL_GL_CONTEXT_FLAGS, SDL_GL_CONTEXT_FORWARD_COMPATIBLE_FLAG)
        SDL_GL_SetAttribute(SDL_GL_MULTISAMPLESAMPLES, samples)

        self.context = SDL_GL_CreateContext(self.window)

    cdef void swap_buffers(self):
        SDL_GL_SwapWindow(self.window)

    def __dealloc__(self):
        SDL_GL_DeleteContext(self.context)
        SDL_DestroyWindow(self.window)
        SDL_Quit()