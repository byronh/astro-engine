#include "gl.h"
#include <stdio.h>
#include <GL/glew.h>
#include <stdlib.h>


void gl_initialize(void) {
    glewExperimental = GL_TRUE;
    GLenum error = glewInit();
    if (error != GLEW_OK) {
        fprintf(stderr, "Failed to initialize glew");
        exit(EXIT_FAILURE);
    }

    glClearDepth(1.0);
}

void gl_info(void) {
    printf("OpenGL version: %s\n", glGetString(GL_VERSION));
    printf("GLSL version: %s\n", glGetString(GL_SHADING_LANGUAGE_VERSION));
    printf("Vendor: %s\n", glGetString(GL_VENDOR));
    printf("Renderer: %s\n", glGetString(GL_RENDERER));
}

void gl_set_clear_color(Color c) {
    glClearColor(c.r, c.g, c.b, c.a);
}

void gl_clear(void) {
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
}