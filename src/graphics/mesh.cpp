#include "mesh.h"
#include "vector3.h"
#include <GL/glew.h>
#include <iostream>


Mesh::Mesh() {
    Vector3 vertices[3];
    vertices[0] = Vector3{-1.0f, -1.0f, 0.0f};
    vertices[1] = Vector3{1.0f, -1.0f, 0.0f};
    vertices[2] = Vector3{0.0f, 1.0f, 0.0f};

    // TODO move to abstraction layer
    glGenBuffers(1, &this->vbo);
    glBindBuffer(GL_ARRAY_BUFFER, this->vbo);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);

    glGenVertexArrays(1, &this->vao);
    glBindVertexArray(this->vao);

    glEnableVertexAttribArray(0);
    glBindBuffer(GL_ARRAY_BUFFER, this->vbo);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 0, NULL);
};

Mesh::~Mesh() {
    glDeleteBuffers(1, &this->vbo);
    glDeleteVertexArrays(1, &this->vao);
}

void Mesh::draw() {
    glBindVertexArray(this->vao);
    glDrawArrays(GL_TRIANGLES, 0, 3);
}
