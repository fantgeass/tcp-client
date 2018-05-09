# TCP

Fault-tolerant TCP client with sample TCP server.
Client always trying to reconnect to the server after an error.

This project has 3 dependencies:
1. poolboy - pool factory (https://github.com/devinus/poolboy)
2. ranch - socket acceptor pool (https://github.com/ninenines/ranch)
3. connection - connection behaviour (https://github.com/fishcakez/connection)


# Getting started

1. Get dependencies ```mix deps.get```
2. Run tests ```mix test```
3. Run console ```iex -S mix```, the app will start supervisors for client and server
4. Send a message using poolboy ```:poolboy.transaction(:client, &(TCP.Client.send(&1, "Message")), 5000)```