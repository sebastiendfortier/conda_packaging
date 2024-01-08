# Docker image to build RPN-SI libs for python-rpn python package   

## Build   

- Prepares ubuntu:$UBUNTU_IMAGE_TAG with the necessary tools to build RPN-SI libraries    
- Get the sources   
- Compile each library   
- Creates a conda env with your user called builder   
- Builds the conda packages   


```shell   
export UBUNTU_IMAGE_TAG=16.04   
make build   
``` 

## Run

To export the packages to anaconda, run the container, you should end up in a folder with all built conda archives ready for upload.     


```shell  
export UBUNTU_IMAGE_TAG=16.04   
make run   
# inside the container   
anaconda login   # enter your credentials     
# upload to anaconda    
anaconda upload <pkgname>.tar.bz2        
```

## Clean

Will clean the docker images  


```shell   
export UBUNTU_IMAGE_TAG=16.04    
make clean    
```






