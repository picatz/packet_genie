require 'sinatra/base'
require 'pcaprub'
require 'base64'
require 'json'
require 'pry'

module PacketGenie

  class Server < Sinatra::Base

    def jsonify(mesg)
      mesg.to_json + "\n"
    end

    def read_json(body)
      JSON.parse(body)
    rescue # don't tell me what to do
      false
    end

    before do
      content_type :json
    end

    set :config, { "interface": Pcap.lookupdev, 
                   "snaplen": 65535, 
                   "promisc": true,
                   "timeout": 0 }

    get '/config' do
      jsonify(settings.config)
    end

    post '/config' do
      halt 400 unless body = read_json(request.body.read)
      ["interface", "snaplen", "promisc", "timeout"].each do |opt|
        settings.config[opt.to_sym] = body[opt] if body.keys.include?(opt)
      end
      jsonify(settings.config)
    end

    get '/packets' do
      cap = PCAPRUB::Pcap.open_live(*settings.config.values)
      stream do |out|
        while true
          if pkt = cap.next
            out << jsonify({ packet: Base64.encode64(pkt) })
          end
        end
      end
    end

    def self.run!(bind: 'localhost', port: 4567, ssl: true, cert_chain: false, private_key: false, verify_peer: false)
      set :bind, bind
      set :port, port
      if ssl
        [ cert_chain, private_key ].each do |required_file|
          raise "Required file #{required_file} is not a file!" unless File.exists?(required_file)
        end
      end
      super do |server|
        if ssl
          server.ssl = true
          server.ssl_options = {
            :cert_chain_file  => cert_chain,
            :private_key_file => private_key,
            :verify_peer      => verify_peer
          }
        end
      end
    end

  end

end
