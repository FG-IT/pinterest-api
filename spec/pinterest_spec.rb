require 'spec_helper'

describe Pinterest do
  it 'has a version number' do
    expect(Pinterest::VERSION).not_to be nil
  end

  describe Pinterest::Client do
    let(:client){Pinterest::Client.new(ENV['ACCESS_TOKEN'])}

    it 'should exist' do
      expect(client).to be_kind_of(Pinterest::Client)
    end

    it 'should be able to set connection request options' do
      timeout_client = Pinterest::Client.new(ENV['ACCESS_TOKEN'], {
        request: {
          timeout: 0.0001,
          open_timeout: 5,
        }
      })
      conn = timeout_client.send(:connection)
      expect(conn.options).to be_a Faraday::RequestOptions
      expect(conn.options.timeout).to be(0.0001)
    end
  end

end
