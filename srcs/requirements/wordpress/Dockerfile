FROM debian:bullseye

RUN apt-get update && apt-get install -y curl php7.4 php-fpm php-mysql mariadb-client

COPY ./tools/script.sh /wordpress.sh

RUN chmod +x wordpress.sh

ENTRYPOINT ["/wordpress.sh"]