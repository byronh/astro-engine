#include "graphics/gl.h"
#include <stdio.h>
#include <GL/glew.h>
#include <glm/gtc/type_ptr.hpp>


namespace gl {

    void initialize(void) {
        glewExperimental = GL_TRUE;
        GLenum error = glewInit();
        if (error != GLEW_OK) {
            fprintf(stderr, "Failed to initialize glew\n");
            exit(EXIT_FAILURE);
        }

        glClearDepth(1.0);
        glEnable(GL_DEPTH_TEST);
        glDepthFunc(GL_LESS);
    }

    void info(void) {
        printf("OpenGL version: %s\n", glGetString(GL_VERSION));
        printf("GLSL version: %s\n", glGetString(GL_SHADING_LANGUAGE_VERSION));
        printf("Vendor: %s\n", glGetString(GL_VENDOR));
        printf("Renderer: %s\n", glGetString(GL_RENDERER));
    }

    void set_clear_color(Color c) {
        glClearColor(c.r, c.g, c.b, c.a);
    }

    void clear(void) {
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    }

    unsigned create_program(void) {
        return glCreateProgram();
    }

    void delete_program(unsigned handle) {
        glDeleteProgram(handle);
    }

    void link_program(unsigned handle) {
        glLinkProgram(handle);
    }

    void use_program(unsigned handle) {
        glUseProgram(handle);
    }

    void validate_program(unsigned handle) {
        GLint status;
        glGetProgramiv(handle, GL_LINK_STATUS, &status);
        if (status == GL_FALSE)
        {
            fprintf(stderr, "Failed to link program:\n");

            GLint length;
            glGetProgramiv(handle, GL_INFO_LOG_LENGTH, &length);
            char* log = new char[length + 1];
            glGetProgramInfoLog(handle, length, NULL, log);
            fprintf(stderr, log);
            delete[] log;

            glDeleteProgram(handle);
            exit(EXIT_FAILURE);
        }

        glValidateProgram(handle);
        glGetProgramiv(handle, GL_VALIDATE_STATUS, &status);
        if (status == GL_FALSE)
        {
            fprintf(stderr, "Failed to validate program:\n");

            GLint length;
            glGetProgramiv(handle, GL_INFO_LOG_LENGTH, &length);
            char* log = new char[length + 1];
            glGetProgramInfoLog(handle, length, NULL, log);
            fprintf(stderr, log);
            delete[] log;

            glDeleteProgram(handle);
            exit(EXIT_FAILURE);
        }
    }

    void attach_shader(unsigned program_handle, unsigned shader_handle) {
        glAttachShader(program_handle, shader_handle);
    }

    unsigned compile_shader(ShaderType type, const char* source) {
        GLenum shader_type;
        if (type == ShaderType::VERTEX) {
            shader_type = GL_VERTEX_SHADER;
        } else if (type == ShaderType::GEOMETRY) {
            shader_type = GL_GEOMETRY_SHADER;
        } else if (type == ShaderType::FRAGMENT) {
            shader_type = GL_FRAGMENT_SHADER;
        } else {
            fprintf(stderr, "Invalid shader type\n");
            exit(EXIT_FAILURE);
        }
        GLuint shader_handle = glCreateShader(shader_type);

        glShaderSource(shader_handle, 1, &source, NULL);
        glCompileShader(shader_handle);

        GLint status;
        glGetShaderiv(shader_handle, GL_COMPILE_STATUS, &status);
        if (status == GL_FALSE)
        {
            fprintf(stderr, "Failed to compile shader:\n");

            GLint length;
            glGetShaderiv(shader_handle, GL_INFO_LOG_LENGTH, &length);
            char* info = new char[length + 1];
            glGetShaderInfoLog(shader_handle, length, NULL, info);
            fprintf(stderr, info);
            delete[] info;

            glDeleteShader(shader_handle);
            exit(EXIT_FAILURE);
        }

        return shader_handle;
    }

    void delete_shader(unsigned handle) {
        glDeleteShader(handle);
    }

    void detach_shader(unsigned program_handle, unsigned shader_handle) {
        glDetachShader(program_handle, shader_handle);
    }

    int get_attribute_location(unsigned program_handle, const char* name) {
        GLint location = glGetAttribLocation(program_handle, name);
        if (location == -1) {
            fprintf(stderr, "Invalid uniform location\n");
            exit(EXIT_FAILURE);
        }
        return location;
    }

    int get_uniform_location(unsigned program_handle, const char* name) {
        GLint location = glGetUniformLocation(program_handle, name);
        if (location == -1) {
            fprintf(stderr, "Invalid uniform location\n");
            exit(EXIT_FAILURE);
        }
        return location;
    }


    void set_uniform_matrix(int location, Matrix4& matrix) {
        glUniformMatrix4fv(location, 1, GL_FALSE, glm::value_ptr(matrix));
    }
}