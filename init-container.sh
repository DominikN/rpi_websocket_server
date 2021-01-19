#!/bin/bash

sysctl net.ipv6.conf.lo.disable_ipv6=0
husarnet daemon > /dev/null 2>&1 &
sleep 5
nginx
husarnet join ${JOINCODE} ${HOSTNAME}
sleep 5
python3 websocket_server.py &
/bin/bash