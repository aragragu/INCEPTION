
FROM debian

RUN apt update && apt install curl -y

WORKDIR /app

COPY script.sh /app/script.sh

CMD ["bash"]
