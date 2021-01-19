#!/bin/bash

function parse_output() {
    local retval="success"

    while read line; do
        if [[ $line == *"ERROR"* ]]; then
            retval="waiting"
        fi
    done
    echo $retval
}

function print_instruction() {
    local retval="::"
    
    while read line; do
        if [[ $line == *"Husarnet IP address:"* ]]; then
            retval=${line#*"Husarnet IP address: "}
        fi
    done
    
    echo "********************************"
    echo "To access a webserver visit:" 
    echo "👉 http://[${retval}]:80 👈"
    echo "in your web browser 💻" 
    echo "********************************"
}

sysctl net.ipv6.conf.lo.disable_ipv6=0

echo ""
echo "Starting Husarnet daemon:"
husarnet daemon > /dev/null 2>&1 &

for i in {1..10}
do
    sleep 1
    
    output=$( parse_output < <(husarnet status) )
    echo "checking status ($i): $output"
    
    if [[ $output != "waiting" ]]; then
        break
    fi
done

echo ""
echo "Connecting to Husarnet network as \"${HOSTNAME}\":"
husarnet join ${JOINCODE} ${HOSTNAME}
echo "done"
echo ""

print_instruction < <(husarnet status)

nginx

python3 websocket_server.py ${BUTTON_PIN} ${LED_PIN} &

/bin/bash