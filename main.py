from astro.application import Application, ApplicationConfig, ApplicationListener
from astro.core.entitymanager import EntityManager
from astro.math.matrix import Matrix4
from astro.math.vector import Vector3
from astro.graphics.camera import Camera
from astro.graphics.renderer import Renderer
from astro.graphics.shader import Shader
from astro.graphics.viewport import Viewport
from astro.input import InputListener, InputMultiplexer, Keys
from os import path


class ExampleGame(ApplicationListener, InputListener):
    def __init__(self):
        super().__init__()
        self.entities = EntityManager()
        self.multiplexer = InputMultiplexer()
        self.multiplexer.add_input_listener(self)
        self.renderer = Renderer()
        self.viewport = Viewport()

        self.cam = Camera(Matrix4.perspective(45, 16 / 9, 0.1, 100))
        self.cam.move_to(Vector3(16, 12, 10))
        self.cam.look_at(Vector3(0, 0, 0))

    def create(self):
        self.app.set_input_listener(self.multiplexer)
        self.renderer.initialize()

        for x in range(-16, 16):
            for y in range(-16, 0):
                for z in range(-16, 16):
                    cube = self.entities.create()
                    self.renderer.add_component(cube, 0, Matrix4(Vector3(x * 3.5, y * 3.5, z * 3.5)))

        vert = path.join('shaders', 'instanced.vert.glsl')
        frag = path.join('shaders', 'instanced.frag.glsl')
        shader = Shader(vert, frag)
        shader.begin()
        print('Uniform location: {}'.format(shader.get_uniform_location('u_combined')))

    def render(self):
        self.cam.update()
        self.renderer.render(self.cam)

    def destroy(self):
        self.renderer.shutdown()

    def resize(self, width: int, height: int):
        self.viewport.resize(width, height)

    def key_down(self, key_code: int):
        if key_code == Keys.KEY_ESCAPE:
            self.app.exit()
        elif key_code == Keys.KEY_A:
            self.cam.rotate(Vector3(0, 1, 0), 10)
        elif key_code == Keys.KEY_D:
            self.cam.rotate(Vector3(0, 1, 0), -10)
        elif key_code == Keys.KEY_W:
            self.cam.rotate(Vector3(0, 0, 1), -10)
        elif key_code == Keys.KEY_S:
            self.cam.rotate(Vector3(0, 0, 1), 10)

    def mouse_move(self, x_pos: float, y_pos: float) -> bool:
        print("({:4.1f}, {:4.1f})".format(x_pos, y_pos))


if __name__ == '__main__':
    config = ApplicationConfig()
    config.title = "Example Game"
    config.width = 1366
    config.height = 768
    config.samples = 8

    app = Application(ExampleGame(), config)
    app.run()