from astro.application import Application, ApplicationConfig, ApplicationListener
from astro.ecs import EntityManager
from astro.graphics.render_system import RenderSystem
from astro.graphics.viewport import Viewport
from astro.input import InputListener, Keys
# from astro.native.graphics import Camera, Vector3, Matrix4
from os import path


class ExampleGame(ApplicationListener, InputListener):

    def __init__(self):
        super().__init__()
        self.entity_manager = EntityManager()
        self.render_system = RenderSystem()
        self.viewport = Viewport()
        # self.camera = Camera(
        #     Matrix4.perspective(45.0, 16.0 / 9.0, 0.1, 100.0),
        #     Matrix4.look_at(Vector3(4, 3, 3), Vector3(0, 0, 0), Vector3(0, 1, 0))
        # )

    def create(self):
        self.app.set_input_listener(self)
        self.render_system.initialize()

        vert = path.join('shaders', 'instanced.vert.glsl')
        frag = path.join('shaders', 'instanced.frag.glsl')
        shader = self.render_system.load_shader(vert, frag)
        shader.begin()
        print("Handle: {}".format(shader.handle))
        print("MVP attribute: {}".format(shader.get_attribute_location("MVP")))

    def destroy(self):
        self.render_system.cleanup()
        self.entity_manager.cleanup()

    def render(self):
        self.render_system.render()

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