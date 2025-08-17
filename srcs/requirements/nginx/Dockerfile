FROM debian:bullseye
# Using Debian Bullseye (stable) as the base image

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y nginx openssl
# 1. Update package index
# 2. Upgrade existing packages
# 3. Install Nginx web server and OpenSSL (for HTTPS certificates)

RUN mkdir -p /etc/nginx/ssl
# Create directory to store SSL/TLS private key and certificate

RUN openssl req -new -x509 -newkey rsa:4096 \
    -nodes -keyout /etc/nginx/ssl/certif.key \
    -out /etc/nginx/ssl/certif.crt -sha256 \
    -days 365 -subj "/C=MA/ST=KH/L=KH/O=42/OU=IT/CN=aragragu.42.fr"
# Creates a self-signed certificate:
# - `req`: Manage certificate signing requests
# - `-new`: Generate a new CSR
# - `-x509`: Output a self-signed certificate instead of a CSR
# - `-newkey rsa:4096`: Create a new RSA key (4096 bits)
# - `-nodes`: Do not encrypt the private key (no passphrase prompt)
# - `-keyout`: Save the private key to this path
# - `-out`: Save the certificate to this path
# - `-sha256`: Use SHA-256 hashing
# - `-days 365`: Valid for 1 year
# - `-subj`: Provide all subject info inline (Country, State, City, Org, Unit, Common Name)

COPY ./conf/nginx.conf /etc/nginx/nginx.conf
# Replace default Nginx config with our custom config
COPY ./tools/script.sh /script.sh
RUN chmod +x script.sh

ENTRYPOINT ["./script.sh"]
# Start Nginx in the foreground (required in Docker