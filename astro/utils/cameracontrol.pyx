from astro.core.input import InputListener, Keys
from astro.graphics.camera import Camera


class DebugCameraController(InputListener):
    def __init__(self, camera, velocity=10):
        """ :type camera: Camera """
        super().__init__()
        self.camera = camera
        self.keys = set()
        self.sensitivity = 0.002
        self.velocity = velocity
        self.mouse_x, self.mouse_y = self.camera.viewport_width / 2, self.camera.viewport_height / 2

        self.FORWARD = Keys.KEY_W
        self.BACKWARD = Keys.KEY_S
        self.STRAFE_LEFT = Keys.KEY_A
        self.STRAFE_RIGHT = Keys.KEY_D

    def key_down(self, key_code):
        self.keys.add(key_code)

    def key_up(self, key_code):
        self.keys.remove(key_code)

    def mouse_move(self, x_pos, y_pos):
        self.mouse_x = x_pos
        self.mouse_y = y_pos

    def update(self, delta_time):
        if self.FORWARD in self.keys:
            self.camera.step(self.velocity * delta_time)
        if self.BACKWARD in self.keys:
            self.camera.step(-self.velocity * delta_time)
        if self.STRAFE_LEFT in self.keys:
            self.camera.strafe(-self.velocity * delta_time)
        if self.STRAFE_RIGHT in self.keys:
            self.camera.strafe(self.velocity * delta_time)
        delta_x = self.camera.viewport_width / 2 - self.mouse_x
        delta_y = self.camera.viewport_height / 2 - self.mouse_y
        self.camera.pitch(delta_y * self.sensitivity)
        self.camera.yaw(delta_x * self.sensitivity)
        self.camera.update()