#pragma once


extern void window_create(char* title, int width, int height, int samples);
extern void window_destroy(void);
extern void window_poll_events(void);
extern void window_swap_buffers(void);