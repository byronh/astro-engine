#pragma once


class Mesh {
public:
    Mesh();
    ~Mesh();

    void draw();

private:
    unsigned vao;
    unsigned vbo;
};