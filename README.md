# Docker image to build RPN-SI libs for python-rpn python package   

## Makefile targets
### Build   

- Prepares ubuntu:$UBUNTU_IMAGE_TAG with the necessary tools to build RPN-SI libraries    
- Get the sources   
- Compile each library   
- Creates a conda env with your user called builder   
- Builds the conda packages   


```shell   
export UBUNTU_IMAGE_TAG=16.04   
make build   
``` 

### Build without cache

```shell   
export UBUNTU_IMAGE_TAG=16.04   
make build-nc   
```

### transfer
- trtansfers the archives to a local directory of your choosing (the image must be built)

```shell   
export CONDA_ARCHIVES=/path  
make transfer   
```

### Run

To export the packages to anaconda, run the container, you should end up in a folder with all built conda archives ready for upload.     


```shell  
export UBUNTU_IMAGE_TAG=16.04   
make run   
# inside the container   
anaconda login   # enter your credentials     
# upload to anaconda    
anaconda upload <pkgname>.tar.bz2        
```

### Clean

Will clean the docker images  


```shell   
export UBUNTU_IMAGE_TAG=16.04    
make clean    
```


## How to make a conda package

### Creating a recipe for linux (Example of the rpnpy package)

- create a base folder for your project
```shell
mkdir eccc_rpnpy
cd eccc_rpnpy
```

- create a folder named conda.recipe for the package you whish to build
```shell
mkdir conda.recipe
```

- clone the repository of the python package in the same folder as conda.recipe
```shell
git clone <git url>
```

- in the conda.recipe create the following file
```shell
cd conda.recipe
vim meta.yaml
```
- example of the eccc_rpnpy meta.yaml
```yaml
package:
  name: eccc_rpnpy
  version: 2.2.0rc3


requirements:
  build:
    - python
    - setuptools

  run:
    - python
    - pytz
    - numpy
    - scipy
    - eccc_librmn >=20.0.3
    - eccc_libezinterpv >=20.0.1
    - eccc_libtdpack >=1.6.3
    - eccc_libvgrid >=6.9.3
    - eccc_libburpc >=1.17

test:
  imports:
    - rpnpy.librmn.all
    - rpnpy.vgd.all
    - rpnpy.utils.fstd3d
    - rpnpy.rpndate
    - rpnpy.burpc.all
    - rpnpy.tdpack.all

about:
  home: https://wiki.cmc.ec.gc.ca/wiki/Python-RPN
  license: LGPL-3.0
  license_family: LGPL
  license_file: LICENSE
  summary: 'CMC python rpn library'

source:
  path: ../python-rpn
```
- create the build.sh file that will be used to build the python package from the setup.py file in the project
```shell
vim build.sh
```

- example of the eccc_rpnpy build.sh (works with pretty much every python package with a setup.py)
```shell
#!/bin/bash

# in this particular case we want to copy some activation scripts that will set and unset EC_LD_LIBRARY_PATH
mkdir $PREFIX/etc/
cp -r $RECIPE_DIR/etc/* $PREFIX/etc/

# Install the Python package (the source path in the mate.yaml is used implicitly)
$PYTHON setup.py install
```

- create the conda_build_config.yaml so that on a build every version of the package will be built in one go
```shell
vim conda_build_config.yaml
```

- example of the eccc_rpnpy conda_build_config.yaml

```yaml
python:
    - 3.9
    - 3.10
    - 3.11
```

## Build the eccc_rpnpy conda package

- cd into the right folder
```shell
#cd <folder containing the conda.recipe folder>
cd eccc_rpnpy
```

- create a conda environment for building conda packages 
```shell
. ssmuse-sh -x /fs/ssm/eccc/cmd/cmds/apps/mamba/master/mamba_2023.11.23_all
mamba create -q -y -n builder conda-build conda-verify boa anaconda-client
. activate builder
```

- build the package
```shell
conda mambabuild conda.recipe -c <necessary channels to find dependencies other than conda-forge>
```

- result should look like this
```shell
~/.conda/envs/builder/conda-bld/linux-64/eccc_rpnpy-2.2.0rc3-py311he53d0f1_0.tar.bz2
~/.conda/envs/builder/conda-bld/linux-64/eccc_rpnpy-2.2.0rc3-py310he53d0f1_0.tar.bz2
~/.conda/envs/builder/conda-bld/linux-64/eccc_rpnpy-2.2.0rc3-py39he53d0f1_0.tar.bz2
```

## Upload the package

- upload the package to your anaconda channel

```shell
. activate builder
anaconda login
# enter your credentials
anaconda upload ~/.conda/envs/builder/conda-bld/linux-64/eccc_rpnpy-2.2.0rc3-py311he53d0f1_0.tar.bz2 ~/.conda/envs/builder/conda-bld/linux-64/eccc_rpnpy-2.2.0rc3-py310he53d0f1_0.tar.bz2 ~/.conda/envs/builder/conda-bld/linux-64/eccc_rpnpy-2.2.0rc3-py39he53d0f1_0.tar.bz2
```










