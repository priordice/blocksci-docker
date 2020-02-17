FROM jupyter/scipy-notebook

USER root
RUN apt-get -y update && \
	apt-get install -y curl && \
	apt-get install -y software-properties-common && \
    add-apt-repository ppa:ubuntu-toolchain-r/test -y && \
    apt-get -y update && \
	apt upgrade -y && \
	apt install -y cmake libtool autoconf libboost-filesystem-dev libboost-iostreams-dev \
	libboost-serialization-dev libboost-thread-dev libboost-test-dev  libssl-dev libjsoncpp-dev \
	libcurl4-openssl-dev libjsoncpp-dev libjsonrpccpp-dev libsnappy-dev zlib1g-dev libbz2-dev \
	liblz4-dev libzstd-dev libjemalloc-dev libsparsehash-dev 

RUN apt-get update -y && \
    apt-get install -y gcc-7 g++-7 
RUN  apt-get install -y git-core

USER $NB_USER
RUN conda install -c conda-forge multiprocess 
RUN conda install -c conda-forge psutil
RUN conda install -c conda-forge pycrypto  
RUN conda install -c conda-forge requests 
RUN conda install -c conda-forge dateparser 
RUN conda install conda-build

USER root
WORKDIR /usr/local/src
RUN git clone https://github.com/citp/BlockSci.git && \
    cd BlockSci && \
    git checkout "v0.6" && \
    git submodule init && \
    git submodule update --recursive && \
    mkdir release && \
	cd release && \
	CC=gcc-7 CXX=g++-7 cmake -DCMAKE_BUILD_TYPE=Release .. && \
	make && \
	make install

WORKDIR /usr/local/src/BlockSci/blockscipy/
ENV CC=gcc-7 
ENV CXX=g++-7 
RUN pip install -e /usr/local/src/BlockSci/blockscipy

RUN fix-permissions $CONDA_DIR
RUN fix-permissions /home/$NB_USER

USER root
CMD ["jupyter", "notebook", "--port=8888", "--no-browser", "--ip=0.0.0.0", "--allow-root"]
