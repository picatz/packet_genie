require 'net/http'
require 'uri'
require 'json'
require 'base64'

module PacketGenie

  class Client
    CONFIG  = "/config"
    PACKETS = "/packets"
    
    attr_accessor :uri, :options, :response

    def initialize(uri:, options: false)
      @uri  = URI.parse(uri)
      @options = if options
                   options 
                 else
                   { use_ssl: @uri.scheme == "https" }
                 end
    end

    def config(parsed: true)
      @response = Net::HTTP.get_response(uri + "/config")
      if parsed
        JSON.parse(@response.body)
      else
        @response
      end
    end

    def set_config(config:, parsed: true)
      old_path  = @uri.path
      @uri.path = CONFIG 
      @request = Net::HTTP::Post.new(@uri)
      @request.body = JSON.dump(config)
      @response = Net::HTTP.start(@uri.hostname, @uri.port, @options) { |http| http.request(@request) }
      if parsed
        JSON.parse(@response.body)
      else
        @response
      end
    end

    def send_request(path:, request: @request)
      old_path  = @uri.path
      @uri.path = path
      Net::HTTP.start(@uri.hostname, @uri.port, @options) { |http| http.request(request) }
      @uri.path = old_path
    end

    def response?
      !!@response
    end

    def packets
      old_path  = @uri.path
      @uri.path = "/packets" 
      @request = Net::HTTP::Get.new(@uri)
      begin
        Net::HTTP.start(@uri.hostname, @uri.port, @options) do |http| 
          http.request(@request) do |resp|
            resp.read_body do |chunk|
              chunk.split.each do |packet|
                yield packet
              end
            end
          end
        end
      ensure
        @uri.path = old_path
        true
      end
    end

  end

end
