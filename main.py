from astro.application import Application, ApplicationConfig, ApplicationListener
from astro.ecs import EntityManager
from astro.graphics.render_system import RenderSystem
from astro.input import InputListener, Keys
from astro.native.graphics import Mesh
from os import path


class ExampleGame(ApplicationListener, InputListener):

    def __init__(self):
        super().__init__()
        self.entity_manager = EntityManager()
        self.render_system = RenderSystem()
        self.mesh = None

    def create(self):
        self.app.set_input_listener(self)
        self.render_system.initialize()
        self.mesh = Mesh()

        vert = path.join('shaders', 'basic.vert.glsl')
        frag = path.join('shaders', 'basic.frag.glsl')
        shader = self.render_system.load_shader(vert, frag)
        shader.begin()

    def destroy(self):
        self.render_system.cleanup()
        self.entity_manager.cleanup()

    def render(self):
        self.render_system.render()
        self.mesh.draw()

    def key_down(self, key_code: int):
        if key_code == Keys.KEY_ESCAPE:
            self.app.exit()


if __name__ == '__main__':
    config = ApplicationConfig()
    config.title = "Example Game"
    config.width = 800
    config.height = 600
    config.samples = 8

    app = Application(ExampleGame(), config)
    app.run()