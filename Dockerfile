FROM ubuntu:18.04

RUN apt update -y

# install webserver service
RUN apt install nginx -y

# install python dependencies
RUN apt install python3.8 -y && \
    apt install python-pkg-resources python3-pkg-resources -y && \
    apt install python3-pip -y && \
    pip3 install RPi.GPIO && \
    pip3 install gpiozero && \
    pip3 install websockets

# install Husarnet client
RUN apt update && \
    apt install -y curl && \
    apt install -y gnupg2 && \
    apt install -y systemd && \
    curl https://install.husarnet.com/install.sh | bash

# some optional modules
RUN apt install vim -y
RUN apt install fonts-emojione -y
RUN apt install iputils-ping -y

# copy project files into the image
COPY init-container.sh /opt

WORKDIR /app
COPY backend_src /app/
COPY frontend_src /var/www/html/

# get on app.husarnet.com
ENV HOSTNAME my-hnet-container
ENV JOINCODE ""

# define ports
ENV HTTP_PORT 80
ENV WEBSOCKET_PORT 8001

EXPOSE $HTTP_PORT
EXPOSE $WEBSOCKET_PORT

# Number of Raspberry Pi pins where button and LED are connected
ENV BUTTON_PIN 23
ENV LED_PIN 16

CMD /opt/init-container.sh