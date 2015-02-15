from astro.native import graphics


class RenderSystem:
    def __init__(self):
        self.rs = graphics.RenderSystem()

    def __del__(self):
        self.cleanup()

    def cleanup(self):
        del self.rs

    def initialize(self):
        self.rs.initialize()

    def update(self, delta_time: float):
        self.rs.update(delta_time)