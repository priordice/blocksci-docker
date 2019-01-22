FROM ubuntu
LABEL maintainer="priordice - dado@fet.at"
LABEL build_date="2018-01-22"

RUN apt-get -y update && \
	apt-get install -y curl && \
	apt-get install -y software-properties-common && \
    add-apt-repository ppa:ubuntu-toolchain-r/test -y && \
    apt-get -y update && \
	apt upgrade -y && \
	apt install -y cmake libtool autoconf libboost-filesystem-dev libboost-iostreams-dev \
	libboost-serialization-dev libboost-thread-dev libboost-test-dev  libssl-dev libjsoncpp-dev \
	libcurl4-openssl-dev libjsoncpp-dev libjsonrpccpp-dev libsnappy-dev zlib1g-dev libbz2-dev \
	liblz4-dev libzstd-dev libjemalloc-dev libsparsehash-dev python3-dev python3-pip && \
    apt-get -y install gcc-6 g++-6

RUN  apt-get install -y git-core

# RUN pip3 install --upgrade pip # commented out - broken import main!
RUN curl https://bootstrap.pypa.io/get-pip.py | python3

RUN pip3 install --upgrade multiprocess psutil jupyter pycrypto matplotlib pandas dateparser

WORKDIR /usr/local/src

RUN git clone https://github.com/citp/BlockSci.git && \
    cd BlockSci && \
    mkdir release && \
	cd release && \
	CC=gcc-7 CXX=g++-7 cmake -DCMAKE_BUILD_TYPE=Release .. && \
	make && \
	make install

#RUN cd .. && \
RUN	CC=gcc-7 CXX=g++-7 pip3 install -v -e /usr/local/src/BlockSci/blockscipy
	
ENV TINI_VERSION v0.6.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini
ENTRYPOINT ["/usr/bin/tini", "--"]
EXPOSE 8888
CMD ["jupyter", "notebook", "--port=8888", "--no-browser", "--ip=0.0.0.0", "--allow-root"]
