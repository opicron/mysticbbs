# Use a more recent Debian version with Python 2.7 (if absolutely necessary)
FROM python:2.7.18-buster

MAINTAINER opicron <opicron@gmail.com>

# Set the working directory
WORKDIR /root

# Update & install necessary packages in a single RUN command
RUN apt-get update && \
    apt-get -y upgrade && \
    dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get -y install \
        unzip unrar procps mc htop wget zip rar && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Ensure unrar works
RUN cp /usr/bin/unrar /usr/bin/rar

# Download and install CL library
RUN wget http://www.mysticbbs.com/downloads/cl3431.zip && \
    unzip -a cl3431.zip && \
    make shared && \
    mv /root/libcl.so.3.4.3 /lib/libcl.so && \
    rm -rf /root/*

# Expose necessary ports
EXPOSE 23/tcp 22/tcp 24554/tcp

# Start the Mystic BBS service
ENTRYPOINT ["/bin/bash", "-c", "exec /mystic/boot.sh"]
CMD ["mystic"]
