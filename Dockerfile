FROM ubuntu:18.04

RUN apt-get update -y
RUN apt-get install vim -y

# webserver
RUN apt-get install nginx -y

# python dependencies
RUN apt-get install python3.8 -y
RUN apt-get install python3-pip -y
RUN pip3 install RPi.GPIO
RUN pip3 install gpiozero
RUN pip3 install websockets
# RUN pip3 install plib3-stdlib
RUN apt-get install python-pkg-resources python3-pkg-resources -y

# copy files
WORKDIR /app
COPY websocket_server.py /app
COPY testgpio.py /app
COPY init-container.sh /app

COPY index.html /var/www/html/index.html
COPY websocket_client.js /var/www/html/websocket_client.js

EXPOSE 80
EXPOSE 8001

ENV HOSTNAME place-your-hostname-here
ENV JOINCODE place-your-joincode-here
ENV BUTTON_PIN 23
ENV LED_PIN 16

RUN apt update && \
    apt install -y curl && \
    apt install -y gnupg2 && \
    apt install -y systemd && \
    curl https://install.husarnet.com/install.sh | bash

CMD /app/init-container.sh