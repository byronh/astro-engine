#!/bin/sh

python setup.py build_ext && python -X faulthandler main.py