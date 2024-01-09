#!/bin/bash

files=$(find /home/fortiers/.conda/envs/builder/conda-bld/ -type f \( -name 'eccc_*.tar.bz2' -o -name 'domcmc*.tar.bz2' -o -name 'fst*.tar.bz2'  \))

cp $files ~/data/.
