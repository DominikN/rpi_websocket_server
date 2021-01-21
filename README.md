# rpi_websocket_server
Web user interface for Raspberry Pi, available over the Internet and using websockets for bi-directional low latency communication..

## install Docker on Raspberry Pi

https://withblue.ink/2020/06/24/docker-and-docker-compose-on-raspberry-pi-os.html

## build the Docker image

```bash
docker build -t hnet_ngnix_srv .
```

## run a container 

### Volumes (named)
It's good for:
- store container data (even `-rm` don't remove that)
- share data between containers

Add `-v dckrhostname_v:/var/lib/husarnet` as a volume to retain Husarnet Client data if we remove the container. `dckrhostname_v` could be whatever. You can name it the same as container, however multiple container can still access it.

### Bind mounts
It's good only for:
- easy access to container logs
- developing a code on your host that can be executed on container without re-running it
- use it only in development, not in production (this is why you still need to COPY project files in the Dockerfile)

Add `-v "/home/pi/tech/rpi_websocket_server/temp:/app/test:ro` as a volume to have a share folder between my host and container (add another annonymous volume `-v /app/test/whatever` (anonymous volume) to exclude `whatever` folder from container file system from synchronization). You can no override files created by container in this shared folder from a host, but the container can override files created by host. `ro` means read-only, so container can not write here.

### command for production
```bash
sudo docker run --rm --privileged -it \
--env HOSTNAME='dckrtest' \
--env JOINCODE='fc94:b01d:1803:8dd8:3333:2222:1234:1111/xxxxxxxxxxxxxxxxx' \
--env BUTTON_PIN='26' \
--env LED_PIN='4' \
-v dckrtest_v:/var/lib/husarnet \
hnet_ngnix_srv
```

if you place an `.env` file with environmental variables listed like:
```
HOSTNAME=dckrtest
JOINCODE=fc94:b01d:1803:8dd8:3333:2222:1234:1111/xxxxxxxxxxxxxxxxx
BUTTON_PIN=26
LED_PIN=4
```

You can then run the container like this:
```bash
sudo docker run --rm --privileged -it \
--env-file ./.env \
-v dckrtest_v:/var/lib/husarnet \
hnet_ngnix_srv
```

TODO: `--privileged` flag is only temporary to access RaspberryPi GPIO. Other options are mentioned here: https://stackoverflow.com/questions/30059784/docker-access-to-raspberry-pi-gpio-pins or `--cap-add SYS_RAWIO` option. But neither works ...

### command for development

If you run a container like this, and make changes in files on hosts, the changes will be available in the container file system
```bash
sudo docker run --rm --privileged -it \
--env HOSTNAME='dckrtest' \
--env JOINCODE='fc94:b01d:1803:8dd8:3333:2222:1234:1111/xxxxxxxxxxxxxxxxx' \
--env BUTTON_PIN='26' \
--env LED_PIN='4' \
-v dckrtest_v:/var/lib/husarnet \
-v "/home/pi/tech/rpi_websocket_server/backend_src:/app:ro" \
-v "/home/pi/tech/rpi_websocket_server/frontend_src:/var/www/html:ro" \
hnet_ngnix_srv
```

or (if you placed environment variables in `.env` file):
```bash
sudo docker run --rm --privileged -it \
--env-file ./.env \
-v dckrtest_v:/var/lib/husarnet \
-v "/home/pi/tech/rpi_websocket_server/backend_src:/app:ro" \
-v "/home/pi/tech/rpi_websocket_server/frontend_src:/var/www/html:ro" \
hnet_ngnix_srv
```

## open a website hosted by container

On any other computer in the same Husarnet network as the container, open a Firefox and open: `http://mycontainer:80` URL.