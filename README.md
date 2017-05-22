![Genie Lamp](https://i.imgur.com/jtBKrjU.png)

# Packet Genie

Packet Genie is a simple packet capturing solution that implements a streaming REST API to orchestrate packet captures in a magical way.

## Why?

Have you ever wanted to stream live packet captures on multiple hosts? Ever just wanted to do that over HTTP(s) with a REST API to make it easy to do? 

### 🚧  Development Notice

This gem is still under development.

## Installation

    $ gem install packet_genie

## Usage

### Server

The Packet Genie server will stream packets on the host running the Packet Genie server. This allows you to perform a live, remote packet capture over HTTP(s).

```ruby
require 'packet_genie'

# Start server without SSL
PacketGenie.server.run!(ssl: false)
```

Then, easily start a packet capture with CURL ( for example ):

```shell
$ curl localhost:4567/packets
```

### Client

Don't want to mess around with CURL? Why not use the Packet Genie client?

```ruby
require 'packet_genie'

client = PacketGenie.client.new(uri: "http://locahost:4567")

client.packets do |packet|
  puts packet # do something with json
end
```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

