class Viewport:
    __slots__ = ['width', 'height']

    def __init__(self):
        self.width = None
        self.height = None

    def resize(self, width: int, height: int):
        self.width, self.height = width, height


class ExtendViewport(Viewport):
    NotImplemented


class FitViewport(Viewport):
    NotImplemented