FROM ubuntu:rolling

# Install any needed packages specified in requirements.txt
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections\
    apt-get update && \
    apt-get upgrade -y -q && \
    apt-get install -y -q \
      build-essential \
      make \
      cmake \
      git \
      bzip2 \
      gcc-arm-none-eabi \
      libstdc++-arm-none-eabi-newlib \
      libnewlib-arm-none-eabi \
      ca-certificates \
      wget \
      curl && \
    apt-get clean
