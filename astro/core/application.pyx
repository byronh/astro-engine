from abc import ABCMeta


class ApplicationConfig:
    def __init__(self):
        self.title = None
        self.width = 800
        self.height = 600
        self.samples = 0


class ApplicationListener(metaclass=ABCMeta):
    def __init__(self, application=None):
        self.app = application

    def create(self):
        return NotImplemented

    def destroy(self):
        return NotImplemented

    def update(self, delta_time):
        return NotImplemented

    def render(self):
        return NotImplemented

    def resize(self, width, height):
        return NotImplemented