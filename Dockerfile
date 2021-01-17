FROM ubuntu:18.04

RUN apt-get update -y

RUN apt-get install vim -y

RUN apt-get install nginx -y
COPY index.html /var/www/html/index.html
COPY websocket_client.js /var/www/html/websocket_client.js
CMD [“nginx”,”-g”,”daemon off;”]

RUN apt-get install python3.8 -y
RUN apt-get install python3-pip -y
RUN pip3 install RPi.GPIO
RUN pip3 install gpiozero
RUN pip3 install websockets
# RUN pip3 install plib3-stdlib
RUN apt-get install python-pkg-resources python3-pkg-resources -y
COPY websocket_server.py /
COPY testgpio.py /

RUN apt update && \
    apt install -y curl && \
    apt install -y gnupg2 && \
    apt install -y systemd && \
    curl https://install.husarnet.com/install.sh | bash

ENTRYPOINT (husarnet daemon > /dev/null 2>&1 &) && /bin/bash