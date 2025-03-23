FROM ubuntu:16.04

# Prevent interactive prompts during build
ENV DEBIAN_FRONTEND=noninteractive

MAINTAINER opicron <opicron@gmail.com>

WORKDIR /root
RUN apt update && apt upgrade -y
RUN dpkg --add-architecture i386 && apt update
RUN apt install -y \
    build-essential \
    unzip \
    unrar \
    zip \
    rar \
    mc \
    wget \
    procps \
    curl \
    dos2unix \
    htop

#    dosemu
#    zip \
#    rar \
#    python3 \
#    vim \
#    nano \
#    locals \

# add python to env
RUN apt update && apt install -y python-minimal
RUN apt update && apt install -y libpython2.7 libpython2.7-dev

# Download and install CL library

#OLD METHOD
WORKDIR /root/cl

RUN wget http://www.mysticbbs.com/downloads/cl3431.zip
#    unzip -a cl3431.zip && \
#    make shared && \
#    mv /root/libcl.so.3.4.3 /lib/libcl.so && \
#    rm -rf /root/*

#ADD http://mysticbbs.com/downloads/cl3431.zip /root/cl/
RUN unzip cl3431.zip
RUN dos2unix tools/*.sh
RUN make shared
RUN mv libcl.so.3.4.3 /lib/libcl.so

# Expose necessary ports
EXPOSE 23/tcp 22/tcp 24554/tcp

#default command, can be overridden
WORKDIR /mystic
#CMD ["/mystic/boot.sh", "override"]
CMD ["/mystic/boot.sh", "mystic"]
