# rpi_websocket_server
Web user interface for Raspberry Pi, available over the Internet and using websockets for bi-directional low latency communication..

## install Docker on Raspberry Pi

https://withblue.ink/2020/06/24/docker-and-docker-compose-on-raspberry-pi-os.html

## build the Docker image

```bash
docker build -t hnet_ngnix_srv .
```

## run a container

```bash
docker run --rm --privileged -it -v /dev/net/tun:/dev/net/tun --cap-add NET_ADMIN --sysctl net.ipv6.conf.all.disable_ipv6=0 hnet_ngnix_srv
```

```bash
sudo docker run --rm --privileged -it --env HOSTNAME='myhostname' --env JOINCODE='fc94:b01d:1803:8dd8:2222:2222:1111:1111/xxxxxxxxxxxxxxxxx' hnet_ngnix_srv
```

TODO: `--privileged` flag is only temporary to access RaspberryPi GPIO. Other options are mentioned here: https://stackoverflow.com/questions/30059784/docker-access-to-raspberry-pi-gpio-pins or `--cap-add SYS_RAWIO` option. But neither works ...


## execute inside container:

```bash
husarnet join <PLACE_JOINCODE_HERE> mycontainer
nginx
python3 websocker_server.py
```

## open a website hosted by container

On any other computer in the same Husarnet network as the container, open a Firefox and open: `http://mycontainer:80` URL.