require 'singleton'
require 'faraday'
require 'faraday_middleware'

#
# HTTP Client Class (HTTPクライアント クラス)
#
# @version 0.1.0
#
class HttpClient
  include Singleton

  ENDPOINT = 'https://api.growthpush.com/'

  #
  # initializer (イニシャライザ)
  #
  def initialize
    @conn = Faraday.new(:url => ENDPOINT) do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.response :logger                  # log requests to STDOUT
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      faraday.use FaradayMiddleware::ParseJson, :content_type => /\bjson$/
    end
  end

  #
  # post (POSTする)
  # @param [String] api api identifier (API識別子)
  # @param [Hash] params http request parameters (HTTPリクエスト パラメータ)
  # @param [Integer] version api version (APIバージョン)
  # @raise [GrowthPushException] exception (例外)
  # @return [HttpResponse] http response (HTTPレスポンス)
  #
  def post(api,params,version = 1)
    url = "/#{version}/#{api}"

    response = @conn.post do |req|
      req.url url
      req.headers['Content-Type'] = 'application/json'
      req.params = params
    end

    http_response = HttpResponse.new(response)

    if !http_response.ok?
      body = http_response.body
      raise GrowthPushException.new(body['message'], response.status)
    end

    http_response
  end

end