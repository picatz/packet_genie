$: << File.expand_path("../../../lib", __FILE__)
require "packet_genie"

client = PacketGenie.client.new(uri: "http://localhost:4567")
client.packets do |packet|
  puts packet # do something with packet json
end
