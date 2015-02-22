#version 330 core

layout(location = 0) in vec3 a_position;
layout(location = 1) in vec3 a_color;
layout(location = 2) in mat4 a_world;

uniform mat4 u_combined;

out vec3 v_fragColor;

void main() {
    v_fragColor = a_color;
    gl_Position = u_combined * a_world * vec4(a_position, 1);
}