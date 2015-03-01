from astro.ecs.entity import EntityManager
from astro.core.application import ApplicationListener
from astro.core.input import InputListener, InputMultiplexer, Keys
from astro.math.matrix import Matrix4
from astro.math.vector import Vector3
from astro.graphics.camera import Camera
from astro.graphics.renderer import Renderer
from astro.graphics.shader import Shader
from astro.graphics.utils.cameracontrol import FirstPersonCameraController
from os import path


class ExampleGame(ApplicationListener, InputListener):
    def __init__(self):
        super().__init__()
        self.entities = EntityManager()
        self.renderer = Renderer()

        self.cam = Camera(self.app.width, self.app.height)
        self.cam_controller = FirstPersonCameraController(self.cam)
        self.cam.move_to(Vector3(16, 12, 10))
        self.cam.look_at(Vector3(0, 0, 0))

        self.multiplexer = InputMultiplexer()
        self.multiplexer.add_input_listeners(self, self.cam_controller)

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

    def update(self, delta_time):
        self.cam_controller.update(delta_time)

    def render(self):
        self.renderer.render(self.cam)

    def resize(self, width, height):
        self.cam.set_viewport(width, height)

    def destroy(self):
        self.renderer.shutdown()

    def key_down(self, key_code: int):
        if key_code == Keys.KEY_ESCAPE:
            return self.app.exit()