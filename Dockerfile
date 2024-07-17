# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.195.0/containers/cpp/.devcontainer/base.Dockerfile
# [Choice] Debian / Ubuntu version (use Debian 11/9, Ubuntu 18.04/21.04 on local arm64/Apple Silicon): debian-11, debian-10, debian-9, ubuntu-21.04, ubuntu-20.04, ubuntu-18.04
ARG VARIANT=ubuntu-22.04
FROM mcr.microsoft.com/vscode/devcontainers/cpp:0-${VARIANT}

# Install any needed packages specified in requirements.txt
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
    apt-get update && \
    apt-get upgrade -y -q && \
    apt-get install -y -q \
    clang-tidy \
    clang-format \
    openocd \
    ncurses-dev \
    libudev-dev \
    ninja-build \
    python3 \
    python3-pip \
    python3-setuptools \
    python3-wheel && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3 1 && \
    update-alternatives --install /usr/bin/python-config python-config /usr/bin/python3-config 1 && \
    update-alternatives --install /usr/bin/pydoc pydoc /usr/bin/pydoc3 1 && \
    apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# Install Github CLI
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null && \
    sudo apt update && \
    sudo apt install gh && \
    apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# Install the last GCC from ARM
ENV ARM_TOOLCHAIN_VERSION 13.3.rel1
ENV ARM_TOOLCHAIN_PATH 13.3.rel1/binrel
ENV ARCH x86_64
ENV TARGET arm-none-eabi

ENV ARM_TOOLCHAIN arm-gnu-toolchain
ENV BASE_INSTALL_FOLDER arm_toolchain
ENV ARM_TOOLCHAIN_BASE_URL https://developer.arm.com/-/media/Files/downloads/gnu
ENV ARM_TOOLCHAIN_BASENAME ${ARM_TOOLCHAIN}-${ARM_TOOLCHAIN_VERSION}-${ARCH}-${TARGET}

ENV ARM_TOOLCHAIN_INSTALL_FOLDER /${BASE_INSTALL_FOLDER}/${ARM_TOOLCHAIN_BASENAME}
ENV ARM_TOOLCHAIN_FILENAME ${ARM_TOOLCHAIN_BASENAME}.tar.xz
ENV ARM_TOOLCHAIN_URL ${ARM_TOOLCHAIN_BASE_URL}/${ARM_TOOLCHAIN_PATH}/${ARM_TOOLCHAIN_FILENAME}

RUN mkdir /${BASE_INSTALL_FOLDER} && \
    cd /${BASE_INSTALL_FOLDER} && \
    wget ${ARM_TOOLCHAIN_URL} -O ${ARM_TOOLCHAIN_FILENAME} && \
    tar xf ${ARM_TOOLCHAIN_FILENAME} && \
    rm ${ARM_TOOLCHAIN_FILENAME}

ENV PATH="${ARM_TOOLCHAIN_INSTALL_FOLDER}/bin:${PATH}"
# make some useful symlinks that are expected to exist
RUN cd /usr/bin                                                              && \
    ln -s ${ARM_TOOLCHAIN_INSTALL_FOLDER}/bin/arm-none-eabi-addr2line        && \            
    ln -s ${ARM_TOOLCHAIN_INSTALL_FOLDER}/bin/arm-none-eabi-ar               && \            
    ln -s ${ARM_TOOLCHAIN_INSTALL_FOLDER}/bin/arm-none-eabi-as               && \            
    ln -s ${ARM_TOOLCHAIN_INSTALL_FOLDER}/bin/arm-none-eabi-c++              && \            
    ln -s ${ARM_TOOLCHAIN_INSTALL_FOLDER}/bin/arm-none-eabi-c++filt          && \            
    ln -s ${ARM_TOOLCHAIN_INSTALL_FOLDER}/bin/arm-none-eabi-cpp              && \            
    ln -s ${ARM_TOOLCHAIN_INSTALL_FOLDER}/bin/arm-none-eabi-elfedit          && \            
    ln -s ${ARM_TOOLCHAIN_INSTALL_FOLDER}/bin/arm-none-eabi-g++              && \            
    ln -s ${ARM_TOOLCHAIN_INSTALL_FOLDER}/bin/arm-none-eabi-gcc              && \
    ln -s ${ARM_TOOLCHAIN_INSTALL_FOLDER}/bin/arm-none-eabi-gcc-10.2.1       && \
    ln -s ${ARM_TOOLCHAIN_INSTALL_FOLDER}/bin/arm-none-eabi-gcc-ar           && \
    ln -s ${ARM_TOOLCHAIN_INSTALL_FOLDER}/bin/arm-none-eabi-gcc-nm           && \
    ln -s ${ARM_TOOLCHAIN_INSTALL_FOLDER}/bin/arm-none-eabi-gcc-ranlib       && \
    ln -s ${ARM_TOOLCHAIN_INSTALL_FOLDER}/bin/arm-none-eabi-gcov             && \
    ln -s ${ARM_TOOLCHAIN_INSTALL_FOLDER}/bin/arm-none-eabi-gcov-dump        && \
    ln -s ${ARM_TOOLCHAIN_INSTALL_FOLDER}/bin/arm-none-eabi-gcov-tool        && \
    ln -s ${ARM_TOOLCHAIN_INSTALL_FOLDER}/bin/arm-none-eabi-gdb              && \
    ln -s ${ARM_TOOLCHAIN_INSTALL_FOLDER}/bin/arm-none-eabi-gdb-add-index    && \
    ln -s ${ARM_TOOLCHAIN_INSTALL_FOLDER}/bin/arm-none-eabi-gdb-add-index-py && \
    ln -s ${ARM_TOOLCHAIN_INSTALL_FOLDER}/bin/arm-none-eabi-gdb-py           && \
    ln -s ${ARM_TOOLCHAIN_INSTALL_FOLDER}/bin/arm-none-eabi-gprof            && \
    ln -s ${ARM_TOOLCHAIN_INSTALL_FOLDER}/bin/arm-none-eabi-ld               && \
    ln -s ${ARM_TOOLCHAIN_INSTALL_FOLDER}/bin/arm-none-eabi-ld.bfd           && \
    ln -s ${ARM_TOOLCHAIN_INSTALL_FOLDER}/bin/arm-none-eabi-lto-dump         && \
    ln -s ${ARM_TOOLCHAIN_INSTALL_FOLDER}/bin/arm-none-eabi-nm               && \
    ln -s ${ARM_TOOLCHAIN_INSTALL_FOLDER}/bin/arm-none-eabi-objcopy          && \
    ln -s ${ARM_TOOLCHAIN_INSTALL_FOLDER}/bin/arm-none-eabi-objdump          && \
    ln -s ${ARM_TOOLCHAIN_INSTALL_FOLDER}/bin/arm-none-eabi-ranlib           && \
    ln -s ${ARM_TOOLCHAIN_INSTALL_FOLDER}/bin/arm-none-eabi-readelf          && \
    ln -s ${ARM_TOOLCHAIN_INSTALL_FOLDER}/bin/arm-none-eabi-size             && \
    ln -s ${ARM_TOOLCHAIN_INSTALL_FOLDER}/bin/arm-none-eabi-strings          && \
    ln -s ${ARM_TOOLCHAIN_INSTALL_FOLDER}/bin/arm-none-eabi-strip

# This is required to get arm-none-eabi-gdb working
RUN  cd /usr/lib/x86_64-linux-gnu && \
    ln -s libncurses.so.6.2 libncurses.so.5 && \
    ln -s libtinfo.so.6.2 libtinfo.so.5
