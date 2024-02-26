#!/bin/bash

# Copy precompiled libraries and binaries
mkdir -p $PREFIX/bin/
cp -r $RECIPE_DIR/../bin/* $PREFIX/bin/

