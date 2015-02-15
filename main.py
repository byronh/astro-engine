from astro.application import Application, ApplicationConfig, ApplicationListener
from astro.ecs import EntityManager
from astro.graphics.render_system import RenderSystem
from astro.input import InputListener, Keys


class ExampleGame(ApplicationListener, InputListener):

    def __init__(self):
        super().__init__()
        self.entity_manager = EntityManager()
        self.render_system = RenderSystem()

    def create(self):
        self.render_system.initialize()
        self.app.set_input_listener(self)

    def destroy(self):
        self.render_system.cleanup()
        self.entity_manager.cleanup()

    def render(self, interpolation: float):
        self.render_system.update(interpolation)

    def key_down(self, key_code: int):
        if key_code == Keys.KEY_ESCAPE:
            self.app.exit()


if __name__ == '__main__':
    config = ApplicationConfig()
    config.title = "Example Game"
    config.width = 800
    config.height = 600
    config.samples = 4

    app = Application(ExampleGame(), config)
    app.run()