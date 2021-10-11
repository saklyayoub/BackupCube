#FROM ubuntu:18.04
FROM debian:jessie
LABEL maintainer="Sakly Ayoub"
LABEL maintianer-email="saklyayoub@gmail.com"
LABEL version="1.0"
ENV TZ=Africa/Tunis
RUN apt-get update -y && \
    apt-get install curl zip unzip wget mysql-client cron -y && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -r awscliv2.zip
VOLUME /var/log/
VOLUME /input
VOLUME /output
COPY ["run.sh", "backup.sh", "/"]
RUN chmod a+x /run.sh /backup.sh && \
    echo $TZ >  /etc/timezone
CMD ["/run.sh"]
