require "packet_genie/version"
require "packet_genie/server"
require "packetgen"

module PacketGenie
  def self.server
    Server
  end
end
