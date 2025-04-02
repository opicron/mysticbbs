FROM ubuntu:24.04

# Prevent interactive prompts during build
ENV DEBIAN_FRONTEND=noninteractive
ENV PYENV_ROOT="/root/.pyenv"
ENV PATH="$PYENV_ROOT/bin:$PYENV_ROOT/shims:$PATH"

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
    git \
    htop

# Install deps for python
RUN apt-get update && apt-get install -y \
    build-essential libssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev \
    libncursesw5-dev xz-utils tk-dev libffi-dev

# Install Python 2.7.18 from source with shared lib support
RUN wget https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz && \
    tar xzf Python-${PYTHON_VERSION}.tgz && \
    cd Python-${PYTHON_VERSION} && \
    ./configure --prefix=/usr/local --enable-shared \
        LDFLAGS="-Wl,-rpath=/usr/local/lib" && \
    make -j"$(nproc)" && \
    make altinstall && \
    cd .. && rm -rf Python-${PYTHON_VERSION}*

# Install pip for Python 2.7 and requests lib
RUN curl https://bootstrap.pypa.io/pip/2.7/get-pip.py -o get-pip.py && \
    python get-pip.py && \
    pip install requests && \
    python -c "import ssl; print(ssl.OPENSSL_VERSION)" && \
    rm get-pip.py

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
#3.4.5 for ubuntu 24.04
RUN wget http://www.mysticbbs.com/downloads/cl345.zip
#This is necessary to compile LC on ubuntu 3.4.5
RUN apt-get install -y gcc-9 g++-9
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 9
RUN update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-9 9

#ADD http://mysticbbs.com/downloads/cl3431.zip /root/cl/
RUN unzip -a cl345.zip
RUN dos2unix tools/*.sh
RUN make shared
RUN mv libcl.so.3.4.5 /lib/libcl.so

RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-13 13
RUN update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-13 13

# Expose necessary ports
EXPOSE 23/tcp 22/tcp 24554/tcp

#default command, can be overridden
WORKDIR /mystic
#CMD ["/mystic/boot.sh", "override"]
CMD ["/mystic/boot.sh", "mystic"]
