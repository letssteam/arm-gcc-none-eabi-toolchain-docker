FROM ubuntu:rolling

# Install any needed packages specified in requirements.txt
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
    apt-get update && \
    apt-get upgrade -y -q && \
    apt-get install -y -q \
      build-essential \
      make \
      cmake \
      git \
      python3 \
      bzip2 \
      gcc-arm-none-eabi \
      libstdc++-arm-none-eabi-newlib \
      libnewlib-arm-none-eabi \
      ca-certificates \
      wget \
      curl && \
    apt-get clean

# make some useful symlinks that are expected to exist
RUN cd /usr/bin \
	&& ln -s idle3 idle \
	&& ln -s pydoc3 pydoc \
	&& ln -s python3 python \
	&& ln -s python3-config python-config

RUN useradd -rm -d /home/buid -s /bin/bash -g root -G sudo -u 1001 build
RUN chown -R build:root /home/buid

USER build
WORKDIR /home/build
