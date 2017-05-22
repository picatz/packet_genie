require "packet_genie/version"
require "packet_genie/client"
require "packet_genie/server"

module PacketGenie

  def self.server
    Server
  end

  def self.client
    Client
  end

end
