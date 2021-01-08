var ws;

window.addEventListener('beforeunload', (event) => {
    ws.close();
    // Cancel the event as stated by the standard.
    event.preventDefault();
    // Older browsers supported custom message
    event.returnValue = '';
});

function mouseDown() {
    ws.send('{"led" : 1}');
}

function mouseUp() {
    ws.send('{"led" : 0}');
}

function WebSocketBegin() {
    if ("WebSocket" in window) {
        // Let us open a web socket
        ws = new WebSocket(
            location.hostname.match(/\.husarnetusers\.com$/) ? "wss://" + location.hostname + "/__port_8001/" : "ws://" + location.hostname + ":8001"
        );

        ws.onopen = function () {
            // Web Socket is connected
        };

        ws.onmessage = function (evt) {
            //create a JSON object
            var jsonObject = JSON.parse(evt.data);
            var cnt = jsonObject.counter;
            var btn = jsonObject.button;

            document.getElementById("cnt").innerText = cnt;
            if (btn == 1) {
                document.getElementById("btn").style.color = "green";
            } else {
                document.getElementById("btn").style.color = "red";
            }
        };

        ws.onclose = function (evt) {
            if (evt.wasClean) {
                alert(`[close] Connection closed cleanly, code=${evt.code} reason=${evt.reason}`);
            } else {
                // e.g. server process killed or network down
                // event.code is usually 1006 in this case
                alert('[close] Connection died');
            }
        };

        ws.onerror = function (error) {
            alert(`[error] ${error.message}`);
        }


    } else {
        // The browser doesn't support WebSocket
        alert("WebSocket NOT supported by your Browser!");
    }
}