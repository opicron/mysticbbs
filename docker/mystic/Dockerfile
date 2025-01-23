# Use Ubuntu 20.04 LTS as base image
FROM ubuntu:20.04

WORKDIR /root

# Avoid timezone interactive dialog
ENV DEBIAN_FRONTEND=noninteractive

# Update and upgrade the system
RUN apt-get update && apt-get -y upgrade

# Install necessary packages
RUN apt-get -y install build-essential unzip unrar procps mc htop wget zip rar cron

# Copy cron file to the cron.d directory
COPY mail-cron /etc/cron.d/mail-cron
RUN chmod +x /etc/cron.d/mail-cron
# Apply cron job
RUN crontab /etc/cron.d/mail-cron

# Clean apt cache
RUN apt-get clean

# Download and extract libcl
RUN wget http://www.mysticbbs.com/downloads/cl3441.zip
RUN unzip -a cl3441.zip
RUN make shared

RUN mv /root/libcl.so.3.4.4 /lib/libcl.so

# Remove downloaded files
RUN rm -fr /root/*

# Copy mystic installer and boot scripts
ADD ./mystic /mystic

# Go to main directory
WORKDIR /mystic

# Expose necessary ports
EXPOSE 23/tcp
EXPOSE 22/tcp
EXPOSE 24554/tcp

# Set entry point
# ENTRYPOINT ["scripts/boot.sh"]
# CMD ["mystic"]

# For debugging purposes (allows you to enter the container)
ENTRYPOINT ["tail", "-f", "/dev/null"]
