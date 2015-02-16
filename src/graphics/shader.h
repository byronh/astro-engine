#pragma once


class Shader {
public:
    Shader(const char* vertex_source, const char* fragment_source);
    virtual ~Shader();

    const unsigned handle;
    void begin();
};