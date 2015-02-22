#pragma once

#include "core/math.h"


typedef struct Color {
    float r;
    float g;
    float b;
    float a;
} Color;


namespace gl {

    enum ShaderType {
        VERTEX,
        GEOMETRY,
        FRAGMENT
    };

    // General
    void initialize(void);
    void info(void);
    void set_clear_color(Color c);
    void clear(void);

    // Shader program functions
    unsigned create_program(void);
    void delete_program(unsigned handle);
    void link_program(unsigned handle);
    void use_program(unsigned handle);
    void validate_program(unsigned handle);

    // Shader functions
    void attach_shader(unsigned program_handle, unsigned shader_handle);
    unsigned compile_shader(ShaderType type, const char* source);
    void delete_shader(unsigned handle);
    void detach_shader(unsigned program_handle, unsigned shader_handle);

    // Attributes and uniforms
    int get_attribute_location(unsigned program_handle, const char* name);
    int get_uniform_location(unsigned program_handle, const char* name);
    void set_uniform_matrix(int location, Matrix4& matrix);

}