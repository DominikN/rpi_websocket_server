#!/bin/bash

function parse_output() {
    local str="ERROR"
    local retval="success"

    while read line; do
        # echo "line: ${line}"
        if [[ $line == *"$str"* ]]; then
            retval="error"
        fi
    done
    echo $retval
}

sysctl net.ipv6.conf.lo.disable_ipv6=0

echo "starting Husarnet daemon"
husarnet daemon > /dev/null 2>&1 &

for i in {1..10}
do
    sleep 1
    
    output=$( parse_output < <(husarnet status) )
    echo "checking status ($i): $output"
    if [[ $output != "error" ]]; then
        break
    fi
done

nginx
husarnet join ${JOINCODE} ${HOSTNAME}
python3 websocket_server.py ${BUTTON_PIN} ${LED_PIN} &
/bin/bash