FROM ubuntu:rolling

# Install any needed packages specified in requirements.txt
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
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
