require 'net/https'
require 'net/http/persistent'
require 'four_tell/request'
require 'json'

class FourTell
  VERSION = "1.0.0"

  # @param [String] api_user
  # @param [String] api_password
  # @param [String] client_alias
  def initialize(api_user, api_password, client_alias)
    @api_user     = api_user
    @api_password = api_password
    @client_alias = client_alias
  end

  # Retrieve a list of recommended product IDs for a given request.
  #
  # @param [FourTell::Request] request
  # @param [Fixnum] timeout Seconds to wait before timing out the request
  # @raise [Timeout::Error, Errno::ECONNREFUSED, Errno::ECONNRESET]
  # @return [Array]
  def recommendations(request, timeout: 3)
    url = URI(request.url)
    response = Timeout::timeout(timeout) {
      http = Net::HTTP::Persistent.new 'fourtell'
      req = Net::HTTP::Get.new(url.request_uri)
      req.basic_auth(@api_user, @api_password)
      http.request(url, req)
    }
    (response && response.code == '200') ? JSON.parse(response.body) : []
  end

  # @return [FourTell::Request]
  def build_request
    FourTell::Request.new(@client_alias)
  end
end
