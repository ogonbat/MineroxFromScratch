FROM vbatts/slackware:current

MAINTAINER cingusoft@gmail.com

USER root
COPY scripts/ /root/scripts
COPY toolchain.sh /root/toolchain.sh
COPY wget-list /root/wget-list
COPY md5sums /root/md5sums

WORKDIR /root
RUN chmod -R 777 scripts
RUN chmod -R 777 toolchain.sh
RUN chmod -R 777 wget-list
RUN chmod -R 777 md5sums
RUN ./toolchain.sh

