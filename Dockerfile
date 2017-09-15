FROM vbatts/slackware:current

MAINTAINER cingusoft@gmail.com

USER root
COPY scripts/ /root/scripts
COPY toolchain.sh /root/toolchain.sh
COPY wget-list /root/wget-list
COPY md5sums /root/md5sums

WORKDIR /root

RUN ./toolchain.sh

