FROM debian:bullseye

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y nginx openssl

RUN mkdir -p /etc/nginx/ssl

RUN openssl req -new -x509 -newkey rsa:4096 \
    -nodes -keyout /etc/nginx/ssl/certif.key \
    -out /etc/nginx/ssl/certif.crt -sha256 \
    -days 365 -subj "/C=MA/ST=KH/L=KH/O=42/OU=IT/CN=aragragu.42.fr"

COPY ./conf/nginx.conf /etc/nginx/sites-available/default

COPY ./tools/script.sh /script.sh

RUN chmod +x script.sh

ENTRYPOINT ["./script.sh"]