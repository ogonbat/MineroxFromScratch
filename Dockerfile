FROM debian:latest

MAINTAINER cingusoft@gmail.com

USER root

RUN apt-get update &&\
    apt-get install -y build-essential bison gawk linux-headers-$(uname -r) texinfo libgmp-dev libmpfr-dev libmpc-dev wget python3-pip libisl-dev libisl15 module-assistant &&\
    ln -fsv /bin/bash /bin/sh

COPY ./scripts/ /root/minerox/scripts
COPY ./toolchain.sh /root/minerox/toolchain.sh
COPY ./wget-list /root/minerox/wget-list
COPY ./md5sums /root/minerox/md5sums

WORKDIR /root
RUN chmod -R 777 minerox
WORKDIR /root/minerox
RUN ./toolchain.sh

