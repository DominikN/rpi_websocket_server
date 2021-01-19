FROM ubuntu:18.04

RUN apt update -y

# install webserver service
RUN apt install nginx -y

# install python dependencies
RUN apt install python3.8 -y
RUN apt install python-pkg-resources python3-pkg-resources -y
RUN apt install python3-pip -y
RUN pip3 install RPi.GPIO
RUN pip3 install gpiozero
RUN pip3 install websockets

# install Husarnet client
RUN apt update && \
    apt install -y curl && \
    apt install -y gnupg2 && \
    apt install -y systemd && \
    curl https://install.husarnet.com/install.sh | bash

# some optional modules
RUN apt install vim -y
RUN apt install fonts-emojione -y

# copy project files into the image
COPY init-container.sh /opt

WORKDIR /app
COPY websocket_server.py testgpio.py /app/
COPY index.html websocket_client.js /var/www/html/

# HTTP server port
EXPOSE 80

# Websocket server port
EXPOSE 8001

# get on app.husarnet.com
ENV HOSTNAME place-your-hostname-here
ENV JOINCODE place-your-joincode-here

# Number of Raspberry Pi pins where button and LED are connected
ENV BUTTON_PIN 23
ENV LED_PIN 16

CMD /opt/init-container.sh