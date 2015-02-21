from abc import ABCMeta
from astro import window
from astro.input import InputListener


class ApplicationConfig:
    def __init__(self):
        self.title = None
        self.width = 800
        self.height = 600
        self.samples = 0


class Application:
    def __init__(self, application_listener, config: ApplicationConfig):
        self.config = config
        self.application_listener = application_listener
        self.application_listener.app = self
        self.input_listener = None
        self.running = False
        self.window = window.Window(self.config)

    def run(self):
        self.window.create()

        window.set_frame_buffer_callback(self.window, self.application_listener.resize)
        window.set_key_callback(self.window, self.on_key_event)

        self.running = True
        self.application_listener.create()
        self.application_listener.resize(self.config.width, self.config.height)

        while self.running:
            self.window.poll_events()

            self.application_listener.update(delta_time=0)
            self.application_listener.render()

            self.window.swap_buffers()

        self.application_listener.destroy()

    def exit(self):
        self.running = False

    def set_input_listener(self, input_listener: InputListener):
        self.input_listener = input_listener

    def on_key_event(self, key_code: int, action: int):
        if self.input_listener:
            if action == 0:
                self.input_listener.key_up(key_code)
            elif action == 1:
                self.input_listener.key_down(key_code)


class ApplicationListener(metaclass=ABCMeta):
    def __init__(self, application: Application=None):
        self.app = application

    def create(self):
        return NotImplemented

    def destroy(self):
        return NotImplemented

    def update(self, delta_time: float):
        return NotImplemented

    def render(self):
        return NotImplemented

    def resize(self, width: int, height: int):
        return NotImplemented