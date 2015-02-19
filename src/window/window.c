#include "window.h"
#include <stdio.h>
#include <stdlib.h>
#include <GLFW/glfw3.h>


static GLFWwindow* window;

void (*window_framebuffer_size_callback)(int width, int height);
void (*window_key_callback)(int key_code, int action);


void on_framebuffer_size(GLFWwindow* window, int width, int height) {
    window_framebuffer_size_callback(width, height);
}

void on_key_down(GLFWwindow* window, int key, int scancode, int action, int mods) {
    window_key_callback(key, action);
}


void window_create(char* title, int width, int height, int samples) {
    if (!glfwInit()) {
        fprintf(stderr, "Failed to initialize GLFW");
        exit(EXIT_FAILURE);
    }

    glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
    glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE);
    glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
    glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
    glfwWindowHint(GLFW_FLOATING, GL_TRUE);
    glfwWindowHint(GLFW_RESIZABLE, GL_FALSE);

    if (samples > 0) {
        glfwWindowHint(GLFW_SAMPLES, samples);
    }

    window = glfwCreateWindow(width, height, title, NULL, NULL);
    if (!window) {
        fprintf(stderr, "Failed to create window");
        glfwTerminate();
        exit(EXIT_FAILURE);
    }
    glfwMakeContextCurrent(window);
    glfwSwapInterval(1);
}

void window_destroy(void) {
    glfwDestroyWindow(window);
    glfwTerminate();
}

void window_poll_events(void) {
    glfwPollEvents();
}

void window_set_framebuffer_size_callback(void (*callback_function)(int width, int height)) {
    window_framebuffer_size_callback = callback_function;
    glfwSetFramebufferSizeCallback(window, on_framebuffer_size);
}

void window_set_key_callback(void (*callback_function)(int key_code, int action)) {
    window_key_callback = callback_function;
    glfwSetKeyCallback(window, on_key_down);
}

void window_swap_buffers(void) {
    glfwSwapBuffers(window);
}