require 'spec_helper'
require_relative '../../lib/puppet_twitch/basic_http_server'

module PuppetTwitch

  describe BasicHttpServer do

    describe '#get_endpoint_and_params' do

      let(:basic_http_server) { BasicHttpServer.new('0.0.0.0', 1234) }

      it 'returns endpoint' do
        endpoint, params = basic_http_server.get_endpoint_and_params('GET /foo HTTP')
        expect(endpoint).to eq '/foo'
      end

      it 'returns endpoint containing punctuation' do
        endpoint, params = basic_http_server.get_endpoint_and_params('GET /foo_bar/baz-baa HTTP')
        expect(endpoint).to eq '/foo_bar/baz-baa'
      end

    end

  end
end
