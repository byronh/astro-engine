from astro.application import Application, ApplicationConfig, ApplicationListener
from astro.core.entity_manager import EntityManager
from astro.core.math import Matrix4, Vector3
from astro.graphics.render_system import RenderSystem
from astro.graphics.viewport import Viewport
from astro.input import InputListener, Keys
from os import path


class ExampleGame(ApplicationListener, InputListener):

    def __init__(self):
        super().__init__()
        self.entities = EntityManager()
        self.renderer = RenderSystem()
        self.viewport = Viewport()

        projection = Matrix4.perspective(45, 16 / 9, 0.1, 100)
        view = Matrix4.look_at(Vector3(4, 3, 3), Vector3(0, 0, 0), Vector3(0, 1, 0))

    def create(self):
        self.app.set_input_listener(self)
        self.renderer.initialize()

        player = self.entities.create()

        vert = path.join('shaders', 'instanced.vert.glsl')
        frag = path.join('shaders', 'instanced.frag.glsl')
        shader = self.renderer.load_shader(vert, frag)
        shader.begin()
        print("Handle: {}".format(shader.handle))
        print("MVP attribute: {}".format(shader.get_attribute_location("MVP")))

    def destroy(self):
        self.renderer.cleanup()

    def render(self):
        self.renderer.render()

    def resize(self, width: int, height: int):
        self.viewport.resize(width, height)

    def key_down(self, key_code: int):
        if key_code == Keys.KEY_ESCAPE:
            self.app.exit()


if __name__ == '__main__':
    config = ApplicationConfig()
    config.title = "Example Game"
    config.width = 1366
    config.height = 768
    config.samples = 8

    app = Application(ExampleGame(), config)
    app.run()