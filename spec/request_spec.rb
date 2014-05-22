require 'spec_helper'

describe FourTell::Request do
  let(:req) {
    FourTell::Request.new('the_client_alias').tap { |r| r.customer_id = 1 }
  }

  def fetch_param(key)
    req.params.fetch(key.to_s)
  end

  describe '#client_alias' do
    specify do
      fetch_param(:clientAlias).must_equal 'the_client_alias'
    end
  end

  describe '#num_results' do
    it 'can be set' do
      req.num_results = 3
      fetch_param(:numResults).must_equal 3
    end

    it 'defaults to 20' do
      fetch_param(:numResults).must_equal 20
    end

    let(:err_msg) { 'num_results must be between 1-20' }
    it 'cannot be <= 0' do
      err = assert_raises(ArgumentError) { req.num_results = 0; req.params }
      assert_equal err_msg, err.message
    end
    it 'cannot be > 20' do
      err = assert_raises(ArgumentError) { req.num_results = 21; req.params }
      assert_equal err_msg, err.message
    end
  end

  describe '#format' do
    it 'is JSON' do
      fetch_param(:format).must_equal 'json'
    end
  end

  describe '#customer_id' do
    it 'is included' do
      req.customer_id = 100
      fetch_param(:customerID).must_equal 100
    end

    it 'is required' do
      r = FourTell::Request.new('the_client_alias')
      err = assert_raises(ArgumentError) { r.params }
      assert_equal 'customer_id is required', err.message
    end
  end

  describe '#result_type' do
    it 'defaults to cross-sell' do
      fetch_param(:resultType).must_equal 0
    end

    it 'converts cross-sell' do
      req.result_type = :cross_sell
      fetch_param(:resultType).must_equal 0
    end

    it 'converts personal' do
      req.result_type = :personal
      fetch_param(:resultType).must_equal 1
    end

    it 'converts similar' do
      req.result_type = :similar
      fetch_param(:resultType).must_equal 2
    end

    it 'throws an error if given an unknown symbol' do
      req.result_type = :magic
      assert_raises(KeyError) { req.params }
    end
  end

  describe '#product_id' do
    it 'is included' do
      req.product_id = 314159
      fetch_param(:productIDs).must_equal 314159
    end
  end

  describe '#click_stream_product_ids' do
    it 'sets these to clickStreamIDs' do
      req.click_stream_product_ids = [3, 1, 4]
      fetch_param(:clickStreamIDs).must_equal '3,1,4'
    end

    it 'dedupes and limits to 5' do
      req.click_stream_product_ids = [3, 1, 4, 1, 5, 9, 2]
      fetch_param(:clickStreamIDs).must_equal '3,1,4,5,9'
    end
  end

  describe '#cart_product_ids' do
    it 'dedupes' do
      req.cart_product_ids = [3, 1, 4, 1, 5, 9, 2]
      fetch_param(:cartIDs).must_equal '3,1,4,5,9,2'
    end
  end

  describe '#page_type' do
    it 'validates' do
      %i(Hm Pdp1 Pdp2 Cat Srch Cart Chkout Bought Admin Other).each do |t|
        req.page_type = t
        fetch_param(:pageType).must_equal t.to_s
      end
    end

    it 'can be nil' do
      req.page_type = nil
      req.params['pageType'].must_be_nil
    end

    it 'raises an error on invalid page_types' do
      req.page_type = 'SECRET HIDEOUT'
      err = assert_raises(ArgumentError) { fetch_param(:pageType) }
      assert_equal 'SECRET HIDEOUT is an invalid page_type', err.message
    end
  end

  describe '#url' do
    let(:base_url) {
      'https://live.4-tell.net/Boost2.0/rest/GetRecIDs/array?clientAlias=the_client_alias&format=json'
    }

    it 'omits empty parameters' do
      req.product_id = 2
      u = base_url + '&customerID=1&numResults=20&resultType=0&productIDs=2'
      req.url.must_equal u
    end
  end
end
