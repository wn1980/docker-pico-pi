FROM ubuntu

LABEL maintainer="Waipot Ngamsaad <waipotn@hotmail.com>"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get upgrade -y && \
    apt-get install --reinstall ca-certificates -y

RUN sed -i -e 's/http:\/\/archive/mirror:\/\/mirrors/' -e 's/http:\/\/security/mirror:\/\/mirrors/' -e 's/\/ubuntu\//\/mirrors.txt/' /etc/apt/sources.list

RUN apt-get update && apt-get install -y \
    locales \
    git \
    sudo \
    build-essential \
    cmake \
    gcc-arm-none-eabi \
    libnewlib-arm-none-eabi \
    doxygen \
    python3 && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set the locale
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8     

# setup user
RUN useradd -m developer && \
    usermod -aG sudo developer && \
    usermod --shell /bin/bash developer && \
    #chown -R developer:developer /workspace && \
    #ln -sfn /workspace /home/developer/workspace && \
    echo developer ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer

USER developer

RUN mkdir -p ~/micro_ros_ws/src &&\
    cd ~/micro_ros_ws/src &&\
    git clone --recurse-submodules https://github.com/raspberrypi/pico-sdk.git &&\
    git clone https://github.com/micro-ROS/micro_ros_raspberrypi_pico_sdk.git

ENV PICO_SDK_PATH=/home/developer/micro_ros_ws/src/pico-sdk
