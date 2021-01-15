FROM ubuntu:20.04

RUN apt-get update -y

RUN apt-get install nginx -y
COPY index.html /var/www/html/index.html
COPY websocket_client.js /var/www/html/websocket_client.js
CMD [“nginx”,”-g”,”daemon off;”]

RUN apt-get install python3.6 -y
RUN apt-get install python3-gpiozero -y
RUN apt-get install python3-websockets -y
RUN apt-get install libpython3-stdlib -y
RUN apt-get install python-pkg-resources python3-pkg-resources -y
COPY websocket_server.py /

RUN apt update && \
    apt install -y curl && \
    apt install -y gnupg2 && \
    apt install -y systemd && \
    curl https://install.husarnet.com/install.sh | bash

ENTRYPOINT (husarnet daemon > /dev/null 2>&1 &) && /bin/bash