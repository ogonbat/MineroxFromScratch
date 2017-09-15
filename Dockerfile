FROM vbatts/slackware:current

MAINTAINER cingusoft@gmail.com

USER root
COPY ./scripts/ /root/minerox/scripts
COPY ./toolchain.sh /root/minerox/toolchain.sh
COPY ./wget-list /root/minerox/wget-list
COPY ./md5sums /root/minerox/md5sums

WORKDIR /root/minerox
RUN chmod -R 777 minerox
RUN ./toolchain.sh

