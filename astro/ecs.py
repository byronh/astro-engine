from astro.native import ecs


class EntityManager:
    def __init__(self):
        self.em = ecs.EntityManager()

    def cleanup(self):
        del self.em

    def create(self):
        return ecs.entity_manager_create(self.em)

    def destroy(self, entity_id: int):
        return ecs.entity_manager_destroy(self.em, entity_id)

    def exists(self, entity_id: int):
        return ecs.entity_manager_exists(self.em, entity_id)

    def __del__(self):
        self.cleanup()