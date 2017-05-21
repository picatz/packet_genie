$: << File.expand_path("../../../lib", __FILE__)
require "packet_genie"

PacketGenie.server.run!(cert_chain: "./examples/server/legit.cert.pem", 
                        private_key: "./examples/server/legit.key.pem")
