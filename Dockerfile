FROM debian:stretch-slim
MAINTAINER KALRONG <xrb@kalrong.net>

WORKDIR /root
RUN sed -i "s#deb http://deb.debian.org/debian stretch main#deb http://deb.debian.org/debian stretch main non-free#g" /etc/apt/sources.list
RUN apt-get update; apt-get -y upgrade
RUN dpkg --add-architecture i386; apt-get update; apt-get -y install libc6:i386 wget build-essential manpages-dev unzip unrar
RUN apt-get clean
ADD http://www.mysticbbs.com/downloads/mys112a39_l64.rar /root
RUN unrar-nonfree x mys112a39_l64.rar
ADD ./mystic /mystic
RUN cp /root/upgrade /mystic/
RUN rm -fr /root/*
RUN wget http://www.mysticbbs.com/downloads/cl3431.zip
RUN unzip -a cl3431.zip
RUN make shared
RUN mv /root/libcl.so.3.4.3 /lib/libcl.so
RUN rm -fr /root/*
WORKDIR /mystic/
RUN ./upgrade
RUN apt-get -y purge wget build-essential manpages-dev unzip unrar
EXPOSE 23/tcp
EXPOSE 22/tcp
ENTRYPOINT mis server
#ENTRYPOINT while true;do sleep 50000 ; done
