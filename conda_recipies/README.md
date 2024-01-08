# Conda packaging recipes

- this project contains subdirectories in which conda.recipe directories are present   
- go into a directory like vgrid       
- create a build environement    
- load mamba `. ssmuse-sh -x /fs/ssm/eccc/cmd/cmds/apps/mamba/master/mamba_2023.11.23_all`    
- create the build env `mamba create -n builder python=3.10 conda-build anaconda-client boa conda-verify`    
- . activate builder
- run `conda mambabuild conda.recipe` you can add channels for dependencies that are not in conda-forge like this `-c fortiers`
- login to anaconda `anaconda login` answer questions
- upload your package `anaconda upload ....tar.bz2`

