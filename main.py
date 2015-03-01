from astro.core.application import ApplicationConfig
from astro.core.platform import DesktopApplication
from game import ExampleGame
import logging


def main():
    logging.basicConfig(format='%(name)s: %(message)s')
    logging.getLogger().setLevel(logging.INFO)

    config = ApplicationConfig()
    config.title = "Example Game"
    config.width = 800
    config.height = 600
    config.samples = 8

    app = DesktopApplication(config)
    app.run(ExampleGame)


if __name__ == '__main__':
    main()