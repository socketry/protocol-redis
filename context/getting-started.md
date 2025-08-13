# Getting Started

This guide explains how to use the `Protocol::Redis` gem to implement the RESP2 and RESP3 Redis protocols for low level client and server implementations.

## Installation

Add the gem to your project:

```bash
$ bundle add protocol-redis
```

## Usage

Here is a basic example communicating over a bi-directional socket pair:

``` ruby
sockets = Socket.pair(Socket::PF_UNIX, Socket::SOCK_STREAM)

client = Protocol::Redis::Connection.new(sockets.first)
server = Protocol::Redis::Connection.new(sockets.last)

client.write_object("Hello World!")
puts server.read_object
# => "Hello World!"
```

## Methods

{ruby Protocol::Redis::Methods} provides access to documented Redis commands. You can use these methods by inluding the module in your class:

``` ruby
class MyRedisClient
	include Protocol::Redis::Methods
	
	def call(*arguments)
		connection = self.acquire # Connection management is up to you
		
		connection.write_request(arguments)
		connection.flush
		
		return connection.read_response
	end
end
```
You can then call Redis commands like this:

``` ruby
client = MyRedisClient.new
client.set("key", "value")
```

### Valkey Support

You can always use `#call` to send any command. This library provides a set of methods for what we believe are the most commonly used commands (in other words, the intersection of Redis and Valkey commands). If you need more commands, youn could define these yourself similarly to how {ruby Protocol::Redis::Methods} does.
