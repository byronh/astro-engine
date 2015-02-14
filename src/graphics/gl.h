#pragma once


typedef struct Color {
    unsigned char r;
    unsigned char g;
    unsigned char b;
    unsigned char a;
} Color;


extern void gl_initialize(void);

extern void gl_set_clear_color(Color c);
extern void gl_clear(void);