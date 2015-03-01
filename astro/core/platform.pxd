cdef extern from "<SDL2/SDL.h>" nogil:
    ctypedef void* SDL_Window
    ctypedef void* SDL_GLContext
    ctypedef void* SDL_Surface

    ctypedef enum SDL_bool:
        pass

    ctypedef struct SDL_DisplayMode:
        int w
        int h

    ctypedef struct SDL_MouseMotionEvent:
        int x
        int y

    ctypedef struct SDL_MouseButtonEvent:
        int x
        int y
        unsigned char button
        unsigned char state

    ctypedef struct SDL_WindowEvent:
        unsigned int type
        unsigned char event
        int data1
        int data2

    ctypedef struct SDL_Keysym:
        unsigned int scancode
        unsigned int sym
        unsigned short mod
        unsigned int unicode

    ctypedef struct SDL_KeyboardEvent:
        unsigned char state
        unsigned char repeat
        SDL_Keysym keysym

    ctypedef struct SDL_TextInputEvent:
        unsigned char *text

    ctypedef struct SDL_TouchFingerEvent:
        long touchId
        long fingerId
        unsigned char state
        unsigned short x
        unsigned short y
        short dx
        short dy
        unsigned short pressure

    ctypedef struct SDL_Event:
        unsigned int type
        SDL_MouseMotionEvent motion
        SDL_MouseButtonEvent button
        SDL_WindowEvent window
        SDL_KeyboardEvent key
        SDL_TextInputEvent text
        SDL_TouchFingerEvent tfinger

    # Events
    int SDL_QUIT
    int SDL_WINDOWEVENT
    int SDL_SYSWMEVENT
    int SDL_KEYDOWN
    int SDL_KEYUP
    int SDL_MOUSEMOTION
    int SDL_MOUSEBUTTONDOWN
    int SDL_MOUSEBUTTONUP
    int SDL_TEXTINPUT
    int SDL_FINGERDOWN
    int SDL_FINGERUP
    int SDL_FINGERMOTION

    # GL Attributes
    int SDL_GL_ACCELERATED_VISUAL
    int SDL_GL_DEPTH_SIZE
    int SDL_GL_RED_SIZE
    int SDL_GL_BLUE_SIZE
    int SDL_GL_GREEN_SIZE
    int SDL_GL_ALPHA_SIZE
    int SDL_GL_STENCIL_SIZE
    int SDL_GL_DOUBLEBUFFER
    int SDL_GL_CONTEXT_DEBUG_FLAG
    int SDL_GL_CONTEXT_FLAGS
    int SDL_GL_CONTEXT_FORWARD_COMPATIBLE_FLAG
    int SDL_GL_CONTEXT_MAJOR_VERSION
    int SDL_GL_CONTEXT_MINOR_VERSION
    int SDL_GL_CONTEXT_PROFILE_CORE
    int SDL_GL_CONTEXT_PROFILE_MASK
    int SDL_GL_MULTISAMPLESAMPLES
    int SDL_GL_RETAINED_BACKING

    # Init flags
    int SDL_INIT_VIDEO
    int SDL_INIT_EVERYTHING

    # Window flags
    int SDL_WINDOW_OPENGL
    int SDL_WINDOW_SHOWN
    int SDL_WINDOW_BORDERLESS
    int SDL_WINDOW_RESIZABLE
    int SDL_WINDOW_FULLSCREEN

    # Window event
    int SDL_WINDOWEVENT_EXPOSED
    int SDL_WINDOWEVENT_MINIMIZED
    int SDL_WINDOWEVENT_RESIZED
    int SDL_WINDOWEVENT_RESTORED
    int SDL_WINDOWEVENT_SIZE_CHANGED

    int SDL_Init(unsigned int flags)
    void SDL_Quit()

    SDL_Window* SDL_CreateWindow(char* title, int x, int y, int w, int h, unsigned int flags)
    void SDL_DestroyWindow(SDL_Window* window)
    char* SDL_GetError()
    SDL_GLContext SDL_GL_CreateContext(SDL_Window* window)
    void SDL_GL_DeleteContext(SDL_GLContext)
    void SDL_GL_SetAttribute(int attribute, int value)
    void SDL_GL_SwapWindow(SDL_Window* window)
    bint SDL_PollEvent(SDL_Event* event)
    void SDL_SetWindowTitle(SDL_Window* window, char* title)
    unsigned int SDL_GetTicks()


cdef extern from "<time.h>" nogil:
    ctypedef long time_t
    int CLOCK_MONOTONIC

    ctypedef struct timespec:
        time_t tv_sec
        long tv_nsec

    int clock_gettime(int clk_id, timespec* tp)


cdef inline double hires_time_seconds():
    cdef timespec monotime
    clock_gettime(CLOCK_MONOTONIC, &monotime)
    return monotime.tv_sec + (monotime.tv_nsec / 1000000000)


cdef class DesktopApplication:
    cdef bint running
    cdef object application_listener
    cdef object config
    cdef object input_listener
    cdef Window window

    cdef void poll_events(self)


cdef class Window:
    cdef SDL_GLContext context
    cdef SDL_Window* window

    cdef void swap_buffers(self)