from astro.application import Application, ApplicationConfig, ApplicationListener
from astro.core.entitymanager import EntityManager
from astro.math.matrix import Matrix4
from astro.math.vector import Vector3
from astro.graphics.camera import Camera
from astro.graphics.renderer import Renderer
from astro.graphics.shader import Shader
from astro.graphics.viewport import Viewport
from astro.input import InputListener, Keys
from os import path


class ExampleGame(ApplicationListener, InputListener):
    def __init__(self):
        super().__init__()
        self.entities = EntityManager()
        self.renderer = None
        self.viewport = Viewport()

        self.cam = Camera(
            projection=Matrix4.perspective(45, 16 / 9, 0.1, 100),
            view=Matrix4.look_at(Vector3(16, 9, 9), Vector3(0, 0, 0), Vector3(0, 1, 0))
        )

    def create(self):
        self.app.set_input_listener(self)

        self.renderer = Renderer()
        self.renderer.initialize()

        entity_id = self.entities.create()
        self.renderer.add_component(entity_id, 0, Matrix4())

        vert = path.join('shaders', 'instanced.vert.glsl')
        frag = path.join('shaders', 'instanced.frag.glsl')
        shader = Shader(vert, frag)
        shader.begin()
        print('Uniform location: {}'.format(shader.get_uniform_location('u_combined')))

    def render(self):
        self.renderer.render(self.cam)

    def destroy(self):
        self.renderer.shutdown()

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