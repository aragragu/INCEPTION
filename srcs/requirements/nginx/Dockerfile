FROM debian:bullseye

RUN apt-get update && apt-get upgrade -y && apt-get install -y ngnix openssl

RUN mkdir -p /etc/ngnix/ssl

COPY ./conf/ngnix.conf /etc/ngnix/
