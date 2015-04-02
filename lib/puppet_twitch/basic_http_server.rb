require 'socket'
require_relative 'logger'
require_relative 'param_parser'

module PuppetTwitch

  class BasicHttpServer

    attr_accessor :logger

    def initialize(bind, port, multiple_threads = true)
      @bind = bind
      @port = port
      @multiple_threads = multiple_threads
      @logger = PuppetTwitch::Logger.new()
      @logger.level = PuppetTwitch::Logger::DEBUG
      @actions = {}
    end

    def start()
      @logger.info 'Starting server ...'
      server = TCPServer.new(@bind, @port)
      @logger.info "Listening on #{@bind}:#{@port}"

      server_loop = proc { |socket|
        begin
          process_request socket
        rescue => e
          @logger.error e.to_s
          socket.puts form_response(500, 'Unexpected error')
        ensure
          socket.close
        end
      }

      loop do
        if @multiple_threads
          Thread.fork(server.accept, &server_loop)
        else
          server_loop.call server.accept
        end
      end
    end

    def process_request(socket)
      client_ip       = socket.peeraddr[3]
      client_hostname = socket.peeraddr[2]
      request         = socket.gets

      endpoint, params = get_endpoint_and_params(request)
      @logger.info "Connection from: #{client_hostname} (#{client_ip}) | Endpoint: #{endpoint} | Params: #{params}"

      response = @actions.has_key?(endpoint) ? @actions[endpoint].call(params) : [400, "Unrecognised endpoint: #{endpoint}"]
      @logger.debug "#{response[0]}: #{response[1]}"

      socket.puts form_response(response[0], response[1])
      @logger.debug "Closing connection from #{client_ip}"
    end

    def endpoint(endpoint, &block)
      @actions[endpoint] = block
    end

    def get_endpoint_and_params(request)
      match = request.match(/^\s*(?<verb>GET|POST|PUT|DELETE) (?<endpoint>[\w\-\/]*)(\?(?<params>\S*)\s*|\s*)HTTP.*/)
      return match['endpoint'], parse_params(match['params'])
    end

    def parse_params(param_string)
      PuppetTwitch::ParamParser.parse(param_string.to_s.strip.split('&'))
    end

    def form_response(status, body)
<<-EOF
HTTP/1.1 #{status}
Content-Type: text/plain
Content-Length: #{body.bytesize}
Connection: close

#{body}
EOF
    end

  end
end
