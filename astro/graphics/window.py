from astro.native import window


class Window:
    def __init__(self, app):
        window.create(app.config.title, app.config.width, app.config.height, app.config.samples)
        window.set_framebuffer_size_callback(app.application_listener.resize)
        window.set_key_callback(app.on_key_event)

    def poll_events(self):
        window.poll_events()

    def swap_buffers(self):
        window.swap_buffers()

    def __del__(self):
        window.destroy()