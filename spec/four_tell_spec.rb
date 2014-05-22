require 'spec_helper'
require 'webmock/minitest'

describe FourTell do
  let(:ft) { FourTell.new('username', 'password', 'client_alias') }

  describe '#recommendations' do
    it 'hits 4Tell' do
      ids = (1..20).to_a.join(',')
      base_url = "live.4-tell.net/Boost2.0/rest/GetRecIDs/array?clientAlias=client_alias&customerID=1&format=json&numResults=20&resultType=0"

      stub_request(:get, "https://username:password@#{base_url}").
        to_return(:status => 200, :body => "[#{ids}]")

      req = MiniTest::Mock.new
      req.expect :url, "https://#{base_url}"
      ft.recommendations(req)

      assert_requested(:get, "https://username:password@#{base_url}")
    end
  end
end
