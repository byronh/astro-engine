#pragma once


typedef struct Color {
    float r;
    float g;
    float b;
    float a;
} Color;


void gl_initialize(void);
void gl_info(void);

void gl_set_clear_color(Color c);
void gl_clear(void);