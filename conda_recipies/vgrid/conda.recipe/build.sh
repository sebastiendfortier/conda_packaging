#!/bin/bash

# Copy precompiled libraries and binaries
mkdir -p $PREFIX/lib/
cp -r $RECIPE_DIR/../lib/libvgrid* $PREFIX/lib/
cd $PREFIX/lib/
LIB=$(ls libvgrid*)
ln -s ${LIB} libvgrid.so

