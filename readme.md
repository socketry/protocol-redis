# Protocol::Redis

Implements the RESP2 and [RESP3](https://github.com/antirez/RESP3) Redis protocols.

[![Development Status](https://github.com/socketry/protocol-redis/workflows/Test/badge.svg)](https://github.com/socketry/protocol-redis/actions?workflow=Test)

## Installation

Add this line to your application's Gemfile:

``` ruby
gem 'protocol-redis'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install protocol-redis

## Usage

``` ruby
sockets = Socket.pair(Socket::PF_UNIX, Socket::SOCK_STREAM)

client = Protocol::Redis::Connection.new(sockets.first)
server = Protocol::Redis::Connection.new(sockets.last)

client.write_object("Hello World!")
puts server.read_object
# => "Hello World!"
```

## Development

Run tests:

```
bundle exec bake test
```

## Contributing

We welcome contributions to this project.

1.  Fork it.
2.  Create your feature branch (`git checkout -b my-new-feature`).
3.  Commit your changes (`git commit -am 'Add some feature'`).
4.  Push to the branch (`git push origin my-new-feature`).
5.  Create new Pull Request.
