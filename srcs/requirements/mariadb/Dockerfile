FROM debian:bullseye

RUN apt-get update &&  apt-get install -y mariadb-server

COPY tools/script.sh /mariadb.sh

RUN chmod +x /mariadb.sh

ENTRYPOINT ["/mariadb.sh"]