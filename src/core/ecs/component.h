#pragma once


class Component {
public:
    static const unsigned int max_components = 1024;

    virtual ~Component() = 0;
};