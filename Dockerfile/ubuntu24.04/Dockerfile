FROM ubuntu:24.04

# Prevent interactive prompts during build
ENV DEBIAN_FRONTEND=noninteractive

MAINTAINER opicron <opicron@gmail.com>

WORKDIR /root
RUN apt update && apt upgrade -y
RUN dpkg --add-architecture i386 && apt update
RUN apt install -y \
    build-essential \
    cron \
    unzip \
    unrar \
    zip \
    rar \
    mc \
    wget \
    procps \
    curl \
    dos2unix \
    nano \
    expect \
    make \
    htop

# Install deps
RUN apt-get update && apt-get install -y \
    build-essential curl git libssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev wget \
    llvm libncursesw5-dev xz-utils tk-dev libffi-dev

# Set up environment so Docker has access to pyenv-installed binaries
ENV PYENV_ROOT="/root/.pyenv"
ENV PATH="$PYENV_ROOT/bin:$PYENV_ROOT/shims:$PATH"

# Install pyenv and Python 2.7.18
RUN git clone https://github.com/pyenv/pyenv.git $PYENV_ROOT && \
    $PYENV_ROOT/bin/pyenv install 2.7.18 && \
    $PYENV_ROOT/bin/pyenv global 2.7.18 && \
    python2.7 --version

# Download pip installs script for Python 2.7
RUN wget https://bootstrap.pypa.io/pip/2.7/get-pip.py
RUN python2.7 get-pip.py
RUN pip2 install requests

# Test SSL
RUN python2.7 -c "import ssl; print(ssl.OPENSSL_VERSION)"


# add logrotate
RUN apt update && apt install -y logrotate

# create folder (or skip without error) and add config
RUN mkdir -p /etc/logrotate.d && \
    echo "/mystic/logs/*.log {" > /etc/logrotate.d/mystic && \
    echo "    maxsize 2M" >> /etc/logrotate.d/mystic && \
    echo "    daily" >> /etc/logrotate.d/mystic && \
    echo "    rotate 5" >> /etc/logrotate.d/mystic && \
    echo "    missingok" >> /etc/logrotate.d/mystic && \
    echo "    compress" >> /etc/logrotate.d/mystic && \
    echo "    notifempty" >> /etc/logrotate.d/mystic && \
    echo "    copytruncate" >> /etc/logrotate.d/mystic && \
    echo "}" >> /etc/logrotate.d/mystic

# Clean apt cache
RUN apt-get clean

# Set temp folder
WORKDIR /root/cl

# Download and install CryptLib library
#3.4.3.1 for Ubuntu 16.04
#RUN wget http://www.mysticbbs.com/downloads/cl3431.zip
#3.4.4.1 for Ubunutu 20.04
#RUN wget http://www.mysticbbs.com/downloads/cl3441.zip

#3.4.5 for ubuntu 22.04?
RUN wget http://www.mysticbbs.com/downloads/cl345.zip
#This is necessary to compile LC on ubuntu 3.4.5
RUN apt-get install -y gcc-9 g++-9
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 9
RUN update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-9 9

#ADD http://mysticbbs.com/downloads/cl3431.zip /root/cl/
#RUN unzip -a cl3431.zip
#RUN unzip -a cl3441.zip
RUN unzip -a cl345.zip
RUN dos2unix tools/*.sh
RUN make shared
#RUN mv libcl.so.3.4.3 /lib/libcl.so
#RUN mv libcl.so.3.4.4 /lib/libcl.so
RUN mv libcl.so.3.4.5 /lib/libcl.so
#RUN rm -rf /root/*

RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-11 11
RUN update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-11 11

# Expose necessary ports
EXPOSE 23/tcp 22/tcp 24554/tcp

#default command, can be overridden
WORKDIR /mystic
#CMD ["/mystic/boot.sh", "override"]
CMD ["/mystic/boot.sh", "mystic"]
