#!/bin/bash

# mkdir $PREFIX/etc/
# cp -r $RECIPE_DIR/etc/* $PREFIX/etc/

# Install the Python package
$PYTHON -m pip install . -vv --no-deps --no-build-isolation
