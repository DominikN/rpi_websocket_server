FROM ubuntu:20.04

RUN apt-get update
RUN apt-get install nginx -y
COPY index.html /var/www/html/index.html

CMD [“nginx”,”-g”,”daemon off;”]
RUN apt update && \
    apt install -y curl && \
    apt install -y gnupg2 && \
    apt install -y systemd && \
    curl https://install.husarnet.com/install.sh | bash

ENTRYPOINT (husarnet daemon > /dev/null 2>&1 &) && /bin/bash