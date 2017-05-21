$: << File.expand_path("../../../lib", __FILE__)
require "packet_genie"

PacketGenie.server.run!(ssl: false)
