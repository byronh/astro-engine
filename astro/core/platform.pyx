# distutils: libraries = SDL2

cimport platform


cdef class Application:
    def __cinit__(self):
        self.running = False

    def __init__(self, config):
        self.config = config
        self.window = platform.Window(config.title.encode('utf-8'), config.width, config.height, config.samples)
        SDL_GetWindowSize(self.window.window, &self.window_width, &self.window_height)

    def exit(self):
        self.running = False
        return True

    @property
    def width(self):
        return self.window_width

    @property
    def height(self):
        return self.window_height

    def run(self, listener_class):
        self.application_listener = listener_class.__new__(listener_class)
        self.application_listener._app = self
        listener_class.__init__(self.application_listener)
        self.application_listener.create()

        self.running = True

        cdef double t = 0.0
        cdef double dt = 0.01

        cdef double current_time = platform.hires_time_seconds()
        cdef double accumulator = 0.0

        cdef double new_time, frame_time

        while self.running:
            self.poll_events()

            new_time = platform.hires_time_seconds()
            frame_time = new_time - current_time
            current_time = new_time

            accumulator += frame_time

            # while accumulator >= dt:
            self.application_listener.update(dt)
                # accumulator -= dt
                # t += dt

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
                    SDL_GetWindowSize(self.window.window, &self.window_width, &self.window_height)
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