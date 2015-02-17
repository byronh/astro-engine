from astro.application import Application, ApplicationConfig, ApplicationListener
from astro.ecs import EntityManager
from astro.graphics.render_system import RenderSystem
from astro.input import InputListener, Keys
# from astro.native.graphics import Camera, Vector3, Matrix4
from os import path


class ExampleGame(ApplicationListener, InputListener):

    def __init__(self):
        super().__init__()
        self.entity_manager = EntityManager()
        self.render_system = RenderSystem()
        # self.camera = Camera(
        #     Matrix4.perspective(45.0, 16.0 / 9.0, 0.1, 100.0),
        #     Matrix4.look_at(Vector3(4, 3, 3), Vector3(0, 0, 0), Vector3(0, 1, 0))
        # )

    def create(self):
        self.app.set_input_listener(self)
        self.render_system.initialize()

        vert = path.join('shaders', 'basic.vert.glsl')
        frag = path.join('shaders', 'basic.frag.glsl')
        shader = self.render_system.load_shader(vert, frag)
        shader.begin()
        print("Handle: {}".format(shader.handle))
        print("MVP uniform: {}".format(shader.get_uniform_location("MVP")))

    def destroy(self):
        self.render_system.cleanup()
        self.entity_manager.cleanup()

    def render(self):
        self.render_system.render()

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