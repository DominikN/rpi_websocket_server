# rpi_websocket_server
Web user interface for Raspberry Pi, available over the Internet and using websockets for bi-directional low latency communication..

## build the Docker image

```bash
docker build -t hnet_ngnix_srv .
```

## run a container

```bash
docker run -it -v /dev/net/tun:/dev/net/tun --cap-add NET_ADMIN --sysctl net.ipv6.conf.all.disable_ipv6=0 hnet_ngnix_srv
```

## execute inside container:

```bash
husarnet join <PLACE_JOINCODE_HERE> mycontainer
nginx
```

## open a website hosted by container

On any other computer in the same Husarnet network as the container, open a Firefox and open: `http://mycontainer:80` URL.