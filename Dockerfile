FROM debian:stretch-slim
MAINTAINER KALRONG <xrb@kalrong.net>

WORKDIR /root
RUN sed -i "s#deb http://deb.debian.org/debian stretch main#deb http://deb.debian.org/debian stretch main non-free#g" /etc/apt/sources.list
RUN apt-get update; apt-get -y upgrade
# openssl libssl-dev
#RUN dpkg --add-architecture i386; apt-get update; apt-get -y install libc6:i386 wget build-essential manpages-dev unzip unrar procps mc libpython2.7 python-pip
#RUN dpkg --add-architecture i386; apt-get update; apt-get -y install libc6:i386 wget build-essential manpages-dev unzip unrar procps mc libpython2.7:i386 python-pip

#install and compile python
RUN dpkg --add-architecture i386; apt-get update
RUN apt-get -y install build-essential checkinstall manpages-dev unzip unrar procps mc htop wget
#RUN apt-get -y install libsqlite3-dev zlib1g-dev libncurses5-dev libgdbm-dev libbz2-dev libreadline-gplv2-dev libssl-dev libdb-dev tk-dev
RUN apt-get -y install libsqlite3-dev zlib1g-dev libncursesw5-dev libgdbm-dev libbz2-dev libreadline-gplv2-dev libssl-dev libdb-dev tk-dev libc6-dev libbz2-dev

#RUN cd /usr/src
RUN wget https://www.python.org/ftp/python/2.7.15/Python-2.7.15.tgz
RUN tar -xzf Python-2.7.15.tgz
RUN cd /root/Python-2.7.15
WORKDIR /root/Python-2.7.15
#RUN cd /usr/src/Python-2.7.18
#RUN ./configure --prefix=/usr --enable-shared
RUN ./configure --prefix=/usr -enable-optimizations -enable-unicode=ucs4 -enable-shared
#RUN make
RUN make install

WORKDIR /root
RUN cp /usr/bin/unrar /usr/bin/rar
RUN apt-get clean
ADD http://www.mysticbbs.com/downloads/mys112a39_l64.rar /root
RUN unrar-nonfree x mys112a39_l64.rar
ADD ./mystic /mystic
RUN cp /root/upgrade /mystic/
ADD ./src /mystic
RUN chmod +x /mystic/boot.sh
RUN chmod +x /mystic/start.sh
RUN chmod +x /mystic/stop.sh
RUN rm -fr /root/*
RUN wget http://www.mysticbbs.com/downloads/cl3431.zip
RUN unzip -a cl3431.zip
RUN make shared
RUN mv /root/libcl.so.3.4.3 /lib/libcl.so
RUN rm -fr /root/*
WORKDIR /mystic/
RUN ./upgrade
#RUN apt-get -y purge wget build-essential manpages-dev unzip unrar
EXPOSE 23/tcp
EXPOSE 22/tcp
#CMD ["/mystic/mis","server"]
#ENTRYPOINT ["/mystic/boot.sh"]
#keeps restarting
#ENTRYPOINT ["/bin/bash", "-c", "/mystic/boot.sh"]
ENTRYPOINT ["/mystic/boot.sh"]
CMD ["mystic"]
#ENTRYPOINT while true;do sleep 50000;done
#CMD ["/bin/bash", "-c", "/mystic/boot.sh"]
#works

