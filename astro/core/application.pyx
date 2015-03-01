from abc import ABCMeta
from platform import Application


class ApplicationConfig:
    def __init__(self):
        self.title = "Astro"
        self.width = 800
        self.height = 600
        self.samples = 0


class ApplicationListener(metaclass=ABCMeta):

    @property
    def app(self) -> Application:
        """ :rtype: Application """
        return self._app

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