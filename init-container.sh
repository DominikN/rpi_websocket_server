#!/bin/bash

sysctl net.ipv6.conf.lo.disable_ipv6=0

echo "starting Husarnet daemon"
husarnet daemon > /dev/null 2>&1 &

for i in {1..5}
do
    sleep 1
    echo "checking status ($i): "
    husarnet status
done

nginx
husarnet join ${JOINCODE} ${HOSTNAME}

sleep 3

python3 websocket_server.py &
/bin/bash