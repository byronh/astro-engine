from astro.application import Application, ApplicationConfig, ApplicationListener
from astro.input import InputListener, Keys


class ExampleGame(ApplicationListener, InputListener):

    def create(self):
        self.app.set_input_listener(self)

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