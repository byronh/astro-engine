from abc import ABCMeta
from enum import IntEnum, unique


class InputListener(metaclass=ABCMeta):
    def key_down(self, key_code):
        return False

    def key_up(self, key_code):
        return False

    def mouse_down(self, button):
        return False

    def mouse_move(self, x_pos, y_pos):
        return False

    def mouse_up(self, button):
        return False


class InputMultiplexer(InputListener):
    def __init__(self):
        self.listeners = []

    def add_input_listeners(self, *input_listeners):
        self.listeners += input_listeners

    def remove_input_listener(self, input_listener):
        self.listeners.remove(input_listener)

    def key_down(self, key_code):
        for listener in self.listeners:
            if listener.key_down(key_code):
                break

    def key_up(self, key_code):
        for listener in self.listeners:
            if listener.key_up(key_code):
                break

    def mouse_down(self, button):
        for listener in self.listeners:
            if listener.mouse_down(button):
                break

    def mouse_move(self, x_pos, y_pos):
        for listener in self.listeners:
            if listener.mouse_move(x_pos, y_pos):
                break

    def mouse_up(self, button):
        for listener in self.listeners:
            if listener.mouse_up(button):
                break


@unique
class Keys(IntEnum):
    KEY_ENTER = 13
    KEY_ESCAPE = 27
    KEY_SPACE = 32
    KEY_0 = 48
    KEY_1 = 49
    KEY_2 = 50
    KEY_3 = 51
    KEY_4 = 52
    KEY_5 = 53
    KEY_6 = 54
    KEY_7 = 55
    KEY_8 = 56
    KEY_9 = 57
    KEY_A = 97
    KEY_B = 98
    KEY_C = 99
    KEY_D = 100
    KEY_E = 101
    KEY_F = 102
    KEY_G = 103
    KEY_H = 104
    KEY_I = 105
    KEY_J = 106
    KEY_K = 107
    KEY_L = 108
    KEY_M = 109
    KEY_N = 110
    KEY_O = 111
    KEY_P = 112
    KEY_Q = 113
    KEY_R = 114
    KEY_S = 115
    KEY_T = 116
    KEY_U = 117
    KEY_V = 118
    KEY_W = 119
    KEY_X = 120
    KEY_Y = 121
    KEY_Z = 122