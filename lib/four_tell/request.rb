require 'set'

class FourTell
  class Request
    # @param [String] client_alias Your 4-Tell account name
    def initialize(client_alias)
      @client_alias = client_alias
      @format       = 'json'
      @num_results  = 20
      @result_type  = :cross_sell
    end

    # *REQUIRED*: The customer_id sent to 4-Tell. This should correspond to the
    # customer ID sent via data exports.
    #
    # @param [Fixnum]
    attr_writer :customer_id

    # The result type to return
    #
    # - cross-sell: recommending something based on a customer's likes
    # - personal: based upon purchase history
    # - similar: just bought a shirt, here's another
    #
    # @param [Symbol]
    attr_writer :result_type

    # The number of desired results between 1-20 (20 is the max limit in the
    # 4-Tell API)
    #
    # @param [Fixnum]
    attr_writer :num_results

    # The product ID of the primary item on the page
    #
    # @param [Fixnum]
    attr_writer :product_id

    # Ordered list of most recently visited to least recently visited product
    # IDs. Only 5 unique product IDs will be included.
    #
    # @param [Array]
    attr_writer :click_stream_product_ids

    # List of product IDs in the customer's cart
    #
    # @param [Array]
    attr_writer :cart_product_ids

    # Help 4-Tell provide the right kind of recommendations for the page
    #
    # Can be one of:
    #  - Hm
    #  - Pdp1
    #  - Pdp2
    #  - Cat
    #  - Srch
    #  - Cart
    #  - Chkout
    #  - Bought
    #  - Admin
    #  - Other
    #
    # @param [Symbol]
    attr_writer :page_type

    # Parameters for the 4-Tell call. Empty parameters are omitted.
    #
    # @return [Hash]
    def params
      {}.tap { |h|
        h['clientAlias']    = client_alias
        h['format']         = format
        h['customerID']     = customer_id
        h['numResults']     = num_results
        h['resultType']     = result_type
        h['productIDs']     = product_id
        h['clickStreamIDs'] = click_stream_product_ids
        h['cartIDs']        = cart_product_ids
        h['pageType']       = page_type
      }.reduce({}) do |h, (k, v)|
        h[k] = v if v
        h
      end
    end

    def url
      u = URI('https://live.4-tell.net/Boost2.0/rest/GetRecIDs/array')
      u.query = URI.encode_www_form(params)
      u.to_s
    end

    private

    RESULT_TYPES = {cross_sell: 0, personal: 1, similar: 2}
    PAGE_TYPES = Set.new(%i(Hm Pdp1 Pdp2 Cat Srch Cart Chkout Bought Admin Other))

    attr_reader :client_alias, :format, :product_id

    def customer_id
      @customer_id or raise(ArgumentError, 'customer_id is required')
    end

    def result_type
      RESULT_TYPES.fetch(@result_type)
    end

    def num_results
      n = Integer(@num_results)

      if n <= 0 || n > 20
        raise(ArgumentError, 'num_results must be between 1-20')
      else
        n
      end
    end

    def click_stream_product_ids
      unless empty_array?(@click_stream_product_ids)
        @click_stream_product_ids.uniq.take(5).join(',')
      end
    end

    def cart_product_ids
      @cart_product_ids.uniq.join(',') unless empty_array?(@cart_product_ids)
    end

    def page_type
      return nil unless @page_type

      if @page_type && !PAGE_TYPES.include?(@page_type)
        raise(ArgumentError, "#{@page_type} is an invalid page_type")
      end
      @page_type.to_s
    end

    def empty_array?(ary)
      ary.nil? || ary.empty?
    end
  end
end
