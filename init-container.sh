#!/bin/bash

function get_status() {
    local status="success"

    while read line; do
        if [[ $line == *"ERROR"* ]]; then
            status="waiting..."
        fi
    done
    echo $status
}

function print_instruction() {
    local ipv6addr="::"
    
    while read line; do
        if [[ $line == *"Husarnet IP address:"* ]]; then
            ipv6addr=${line#*"Husarnet IP address: "}
        fi
    done
    
    echo "*******************************************"
    echo "💡 Tip"
    echo "To access a webserver visit:"
    echo "👉 http://[${ipv6addr}]:80 👈"
    echo "in your web browser 💻" 
    echo "*******************************************"
    echo ""
}

if [[ ${JOINCODE} == "" ]]; then
    echo ""
    echo "ERROR: no JOINCODE provided in \"docker run ... \" command. Visit https://app.husarnet.com to get a JOINCODE"
    echo ""
    /bin/bash
    exit
fi

sysctl net.ipv6.conf.lo.disable_ipv6=0

echo ""
echo "⏳ [1/2] Initializing Husarnet Client:"
husarnet daemon > /dev/null 2>&1 &

for i in {1..10}
do
    sleep 1
    
    output=$( get_status < <(husarnet status) )
    echo "$output"
    
    if [[ $output != "waiting..." ]]; then
        break
    fi
done

echo ""
echo "🔥 [2/2] Connecting to Husarnet network as \"${HOSTNAME}\":"
husarnet join ${JOINCODE} ${HOSTNAME}
echo "done"
echo ""

nginx

python3 websocket_server.py ${BUTTON_PIN} ${LED_PIN} &

print_instruction < <(husarnet status)

/bin/bash