#!/bin/bash

# Copy precompiled libraries and binaries
mkdir -p $PREFIX/lib/ 
cp -r $RECIPE_DIR/../lib/* $PREFIX/lib/


