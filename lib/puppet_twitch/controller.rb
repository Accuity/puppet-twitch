#!/usr/bin/env ruby

require_relative 'basic_http_server'
require_relative 'param_parser'
require_relative 'puppet'
require_relative 'version'

module PuppetTwitch

  args = ParamParser.parse(ARGV)

  bind  = args[:bind] || '0.0.0.0'
  port  = args[:port] || 2023
  threads = true

  @processing_request = Mutex.new
  http_server = PuppetTwitch::BasicHttpServer.new(bind, port, threads)

  http_server.endpoint '/puppet/twitch' do |params|
    response = []
    if @processing_request.try_lock
      begin
        if PuppetTwitch::Puppet.is_running?
          response = [409, 'Puppet already running']
        else
          async = (params[:async].to_s != 'false')
          PuppetTwitch::Puppet.run_puppet(async)
          response = async ? [202, 'Triggered puppet run'] : [200, 'Puppet run complete']
        end
      rescue => e
        http_server.logger.error e.to_s
        response = [500, 'Error running puppet']
      ensure
        @processing_request.unlock
      end
    else
      response = [409, 'Puppet already running']
    end
    response
  end

  http_server.endpoint '/info' do
    [200, 'Puppet Twitch - A simple endpoint for triggering puppet']
  end

  http_server.start

end
