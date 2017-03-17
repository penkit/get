require 'net/http'
require 'openssl'
require 'json'

class SlackMessage
  attr_accessor :uri, :channel, :text

  # Converts URL to URI
  def initialize(url, channel, title, body)
    @uri = get_uri(url)
    @channel = channel
    @title = title
    @body = body
  end
  
  # Sends message
  def send
    http = create_http # Create HTTP object
    set_ssl(http) # Sets SSL settings
    req = create_request # Create HTTP post object
    req.body =  { channel: @channel, 
                  color: "#0dba89", 
                  fields: [
                    title: @title, 
                    value: @body
                  ] 
                }.to_json # Creates payload
    http.request(req) # Sends post
  end

  private
    def get_uri(url)
      URI(url)
    end

    def create_http
      Net::HTTP.new(@uri.host, @uri.port)
    end

    def create_request
      Net::HTTP::Post.new(@uri, 'Content-Type' => 'application/json')
    end

    def set_ssl(http)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      http
    end
end