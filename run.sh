#!/bin/sh

python setup.py build_ext --inplace && python -X faulthandler main.py