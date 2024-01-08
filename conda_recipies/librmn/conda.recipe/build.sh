#!/bin/bash

# Copy precompiled libraries and binaries
mkdir -p $PREFIX/lib/
cp -r $RECIPE_DIR/../lib/* $PREFIX/lib/
cd $PREFIX/lib/
LIB=$(ls librmn*)
VERSION=$(echo ${LIB}|cut -d "." -f3)
ln -s ${LIB} librmn.so.${VERSION}
ln -s ${LIB} librmn.so

