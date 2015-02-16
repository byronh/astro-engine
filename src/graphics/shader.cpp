#include "shader.h"
#include "gl.h"


Shader::Shader(const char* vertex_source, const char* fragment_source) : handle(gl::create_program()) {
    unsigned vertex_shader = gl::compile_shader(gl::ShaderType::VERTEX, vertex_source);
    unsigned fragment_shader = gl::compile_shader(gl::ShaderType::FRAGMENT, fragment_source);

    gl::attach_shader(this->handle, vertex_shader);
    gl::attach_shader(this->handle, fragment_shader);

    gl::link_program(this->handle);

    gl::detach_shader(this->handle, vertex_shader);
    gl::detach_shader(this->handle, fragment_shader);

    gl::delete_shader(vertex_shader);
    gl::delete_shader(fragment_shader);

    gl::validate_program(this->handle);
}

Shader::~Shader() {
    gl::delete_program(this->handle);
}

void Shader::begin() {
    gl::use_program(this->handle);
}

int Shader::get_uniform_location(const char* name) {
    return gl::get_uniform_location(this->handle, name);
}
