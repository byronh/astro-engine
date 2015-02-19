#pragma once

#ifdef __cplusplus
extern "C"
{
#endif


extern void window_create(char* title, int width, int height, int samples);
extern void window_destroy(void);
extern void window_poll_events(void);
extern void window_set_framebuffer_size_callback(void (*callback_function)(int width, int height));
extern void window_set_key_callback(void (*callback_function)(int key_code, int action));
extern void window_swap_buffers(void);


#ifdef __cplusplus
}
#endif