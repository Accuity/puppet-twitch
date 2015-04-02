require 'spec_helper'
require_relative '../../lib/puppet_twitch/param_parser'

module PuppetTwitch

  describe ParamParser do

    describe '.parse' do

      it 'converts param keys to symbols' do
        params = ParamParser.parse ['foo=bar']
        expect(params).to have_key :foo
      end

      it 'parses multiple key value params' do
        params = ParamParser.parse ['foo=bar', 'baz=baa']
        expect(params).to eq( {:foo => 'bar', :baz => 'baa'} )
      end

      it 'empty params are set to true' do
        params = ParamParser.parse ['foo', 'bar']
        expect(params).to eq( {:foo => true, :bar => true} )
      end

      it 'returns empty hash for empty input array' do
        params = ParamParser.parse []
        expect(params).to eq( {} )
      end

      it 'raises error when param is malformed' do
        expect {
          ParamParser.parse ['foo=bar=baz']
        }.to raise_error StandardError, /Invalid parameter format/
      end

      it 'raises error when param value is missing' do
        expect {
          ParamParser.parse ['foo=']
        }.to raise_error StandardError, /Invalid parameter format/
      end

    end
  end
end
