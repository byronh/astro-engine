#pragma once

#include "system.h"


class RenderSystem: public System {
public:
    virtual ~RenderSystem();
    virtual void initialize() override;
    virtual void update(float delta_time) override;
};