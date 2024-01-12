ARG TAG

FROM ubuntu:$TAG as builder

COPY 02nocache /etc/apt/apt.conf.d/02nocache
COPY 01_nodoc /etc/dpkg/dpkg.cfg.d/01_nodoc

ARG UID
ARG GID
ARG UNAME
ARG GNAME
RUN groupadd -g $GID -o $GNAME && \
    useradd -u $UID -g $GID -ms /bin/bash $UNAME 

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt update -y && \
    apt install -y software-properties-common build-essential wget gfortran libopenmpi-dev libssl-dev && \
    add-apt-repository ppa:git-core/ppa && \
    apt update -y && \    
    apt install git -y 

RUN wget https://github.com/Kitware/CMake/releases/download/v3.28.1/cmake-3.28.1.tar.gz && \
    tar zxvf cmake-3.28.1.tar.gz && \
    cd cmake-3.28.1 && \
    ./configure --prefix=/opt/cmake && \
    make -j8 && \
    make install

ENV PATH=$PATH:/opt/cmake/bin


WORKDIR /gitlab

RUN git clone --recursive https://github.com/sebastiendfortier/librmn.git && \
    git clone --recursive https://github.com/sebastiendfortier/vgrid.git && \
    git clone --recursive https://github.com/sebastiendfortier/tdpack.git && \
    git clone --recursive https://github.com/sebastiendfortier/libburpc.git && \
    git clone --recursive https://github.com/sebastiendfortier/ezinterpv.git


SHELL ["/bin/bash", "-c"]


RUN  sed -i 's/ -Wno-integer-division//g' librmn/App/src/CMakeLists.txt

 
RUN mkdir librmn_build && \
    cd librmn_build && \
    cmake /gitlab/librmn -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/ -DCOMPILER_SUITE=GNU -DWITH_OPENMP=no && \
    make -j8 && \
    make install

RUN mkdir vgrid_build && \
    cd vgrid_build && \
    cmake /gitlab/vgrid -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/ -DCOMPILER_SUITE=GNU -DWITH_OPENMP=no && \
    make -j8 && \
    make install

RUN mkdir tdpack_build && \
  cd tdpack_build && \
  cmake /gitlab/tdpack -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/ -DCOMPILER_SUITE=GNU -DWITH_OPENMP=no && \
  make -j8 && \
  make install

RUN mkdir libburpc_build && \
    cd libburpc_build && \
    cmake /gitlab/libburpc -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/ -DCOMPILER_SUITE=GNU -DWITH_OPENMP=no && \
    make -j8 && \
    make install

RUN mkdir ezinterpv_build  && \
    cd ezinterpv_build  && \
    cmake /gitlab/ezinterpv -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/ -DCOMPILER_SUITE=GNU -DWITH_OPENMP=no  && \
    make -j8  && \
    make install

USER $UNAME
WORKDIR /home/$UNAME

RUN mkdir rmn_libs &&\
    cp `find /lib -maxdepth 1 -name "*so*" -type f | grep -v ompi` rmn_libs/. &&\
    cp /lib/libez*.a rmn_libs/. &&\
    if [ -d "/usr/lib/x86_64-linux-gnu" ]; then cp /usr/lib/x86_64-linux-gnu/libgfortran.so* rmn_libs/.; fi && \
    if [ -d "/usr/lib/powerpc64le-linux-gnu" ]; then cp /usr/lib/powerpc64le-linux-gnu/libgfortran.so* rmn_libs/.; fi

RUN rm -rf /*.deb && \
    rm -rf /home/$UNAME/gitlab


##############################################################################

FROM condaforge/miniforge3:latest as conda

ARG UID
ARG GID
ARG UNAME
ARG GNAME
RUN groupadd -g $GID -o $GNAME && \
    useradd -u $UID -g $GID -ms /bin/bash $UNAME 

SHELL ["/bin/bash", "-c"]

COPY 02nocache /etc/apt/apt.conf.d/02nocache
COPY 01_nodoc /etc/dpkg/dpkg.cfg.d/01_nodoc

RUN apt-get update -y && apt-get install -y make git nano unzip

USER $UNAME

RUN mamba create -q -y -n builder boa conda-build conda-verify anaconda-client 

COPY --from=builder /home/$UNAME/rmn_libs /home/$UNAME/rmn_libs

WORKDIR /home/$UNAME

RUN git clone --recursive https://github.com/sebastiendfortier/conda_packaging.git && sleep 5

WORKDIR /home/$UNAME/conda_packaging/conda_recipies/

RUN mkdir -p ezinterpv/lib && \
    cp /home/$UNAME/rmn_libs/libezint* ezinterpv/lib/. 

RUN mkdir -p libburpc/lib && \
    cp /home/$UNAME/rmn_libs/libburp_c.so* libburpc/lib/. 

RUN mkdir -p librmn/lib && \
    cp /home/$UNAME/rmn_libs/librmn.so* librmn/lib/. && \
    cp /home/$UNAME/rmn_libs/libApp.so* librmn/lib/. 

RUN mkdir -p support_libraries/lib && \
    cp /home/$UNAME/rmn_libs/libgfortran.so.*.*.* support_libraries/lib/. 

RUN mkdir -p vgrid/lib && \
    cp /home/$UNAME/rmn_libs/libvgrid.so* vgrid/lib/. 

RUN mkdir -p tdpack/lib && \
    cp /home/$UNAME/rmn_libs/libtdpack.so* tdpack/lib/.

# WORKDIR /home/$UNAME/conda_packaging/conda_recipies/ezinterpv

# RUN source activate builder && conda mambabuild conda.recipe -c fortiers

# WORKDIR /home/$UNAME/conda_packaging/conda_recipies/support_libraries

# RUN source activate builder && conda mambabuild conda.recipe -c fortiers

# WORKDIR /home/$UNAME/conda_packaging/conda_recipies/librmn

# RUN source activate builder && conda mambabuild conda.recipe -c fortiers

# WORKDIR /home/$UNAME/conda_packaging/conda_recipies/libburpc

# RUN source activate builder && conda mambabuild conda.recipe -c fortiers

# WORKDIR /home/$UNAME/conda_packaging/conda_recipies/vgrid

# RUN source activate builder && conda mambabuild conda.recipe -c fortiers

# WORKDIR /home/$UNAME/conda_packaging/conda_recipies/tdpack

# RUN source activate builder && conda mambabuild conda.recipe -c fortiers

# WORKDIR /home/$UNAME/conda_packaging/conda_recipies/python-rpn

# RUN source activate builder && conda mambabuild conda.recipe -c fortiers

# WORKDIR /home/$UNAME/conda_packaging/conda_recipies/fstd2nc

# RUN sed -i "s/,'fstd2nc-deps >= 0.20200304.0'//g" fstd2nc/setup.py

# RUN source activate builder && conda mambabuild conda.recipe -c fortiers

# WORKDIR /home/$UNAME/conda_packaging/conda_recipies/fstpy

# RUN sed -i "s/,'fstd2nc-deps >= 0.20200304.0'//g" fstpy/setup.py

# RUN source activate builder && conda mambabuild conda.recipe -c fortiers

# WORKDIR /home/$UNAME/conda_packaging/conda_recipies/domcmc

# RUN source activate builder && conda mambabuild conda.recipe -c fortiers

COPY transfer.sh /home/$UNAME/transfer.sh 

USER root

RUN rm -rf /*.deb

USER $UNAME

WORKDIR /home/$UNAME/conda_packaging/conda_recipies
