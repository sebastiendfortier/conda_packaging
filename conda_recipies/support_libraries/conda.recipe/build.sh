#!/bin/bash

# Copy precompiled libraries and binaries
mkdir -p $PREFIX/lib/
cp -r $RECIPE_DIR/../lib/libgfortran.so.*.*.* $PREFIX/lib/
cd $PREFIX/lib/
LIB=$(ls libgfortran.so.*.*.*)
VERSION=$(echo ${LIB}|cut -d "." -f3)
ln -s ${LIB} libgfortran.so.${VERSION}
