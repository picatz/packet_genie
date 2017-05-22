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

    def config(json: true)
      @response = Net::HTTP.get_response(uri + "/config")
      if json
        JSON.parse(@response.body)
      else
        @response
      end
    end

    def promisc(on: true, off: !on)
      @request = Net::HTTP::Post.new(@uri)
      if off
        @request.body = JSON.dump({"promisc" => false})
      elsif on
        @request.body = JSON.dump({"promisc" => true})
      end
      get_response(path: CONFIG, request: @request)
    end

    def snaplen(value)
      @request = Net::HTTP::Post.new(@uri)
      @request.body = JSON.dump({"snaplen" => value.to_i})
      get_response(path: CONFIG, request: @request)
    end

    def timeout(value)
      @request = Net::HTTP::Post.new(@uri)
      @request.body = JSON.dump({"timeout" => value.to_i})
      get_response(path: CONFIG, request: @request)
    end 

    def interface(name)
      @request = Net::HTTP::Post.new(@uri)
      @request.body = JSON.dump({"interface" => name})
      get_response(path: CONFIG, request: @request)
    end

    def send_request(path:, request: @request)
      @request = Net::HTTP::Post.new(@uri)
      @uri.path = path
      Net::HTTP.start(@uri.hostname, @uri.port, @options) { |http| http.request(request) }
    end

    def get_response(path:, request: @request)
      @response = send_request(path: path, request: request)
    end

    def response?
      !!@response
    end

  end

end
