# TCP

Fault-tolerant TCP client with sample TCP server.  
`Collector` is a producer and stores messages in the buffer.  
`Sender` is a consumer and sends messages from the `Collector`.
If `Sender` failed to deliver messages N times, then it logs an error.
 
This project has 3 dependencies:
1. GenStage - Producer and consumer pipelines with back-pressure (https://github.com/elixir-lang/gen_stage)
2. ranch - socket acceptor pool (https://github.com/ninenines/ranch)
3. dialyxir -  mix tasks for Dialyzer (https://github.com/jeremyjh/dialyxir)


# Getting started

1. Get dependencies ```mix deps.get```
2. Run tests ```mix test```
3. Run type check ```mix dialyzer```
4. Run console ```iex -S mix```, the app will start supervisors for client and server
5. Send a message putting it in the Collector ```TCP.Collector.send("MESSAGE")```