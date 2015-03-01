from astro.core.application import ApplicationConfig
from astro.core.platform import Application
from game import ExampleGame
import logging


def main():
    logging.basicConfig(format='%(name)s: %(message)s')
    logging.getLogger().setLevel(logging.INFO)

    config = ApplicationConfig()
    config.title = "Example Game"
    config.width = 1366
    config.height = 768
    config.samples = 8

    app = Application(config)
    app.run(ExampleGame)


if __name__ == '__main__':
    main()