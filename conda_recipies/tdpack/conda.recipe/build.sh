#!/bin/bash

# Copy precompiled libraries and binaries
mkdir -p $PREFIX/lib/
cp -r $RECIPE_DIR/../lib/* $PREFIX/lib/
cd $PREFIX/lib/
LIB=$(ls libtdpack*)
ln -s ${LIB} libtdpack.so
