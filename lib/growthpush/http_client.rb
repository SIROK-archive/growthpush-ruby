require 'singleton'
require 'faraday'
require 'faraday_middleware'

class HttpClient
  include Singleton

  ENDPOINT = 'https://api.growthpush.com/';

  def initialize
  end

  def post(api,params,version = 1)
    url = "/#{version}/#{api}"

    conn = Faraday.new(:url => ENDPOINT) do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.response :logger                  # log requests to STDOUT
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      faraday.use FaradayMiddleware::ParseJson, :content_type => /\bjson$/
    end

    response = conn.post do |req|
      req.url url
      req.headers['Content-Type'] = 'application/json'
      req.params = params
    end

    http_response = HttpResponse.new(response)

    if !http_response.is_ok?
      body = http_response.body
      raise GrowthPushException.new(body['message'], response.status)
    end

    http_response
  end

end