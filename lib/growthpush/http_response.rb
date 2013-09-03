#
# HTTP Response Class (HTTPレスポンス クラス)
#
# @!attribute [r] header
#  @return [Hash] http response headers (HTTPレスポンス・ヘッダ)
# @!attribute [r] body
#  @return [Hash] http response body (HTTPレスポンス・ボディ)
#
class HttpResponse

  attr_reader :header
  attr_reader :body

  #
  # initializer (イニシャライザ)
  # @param [Faraday::Response] response http response (HTTPレスポンス)
  #
  def initialize(response)
    @response = response
    @header = response.headers
    @body = response.body
  end

  #
  # return result of http request (HTTPリクエストの成否を返す)
  # @return [TrueClass,FalseClass] result (成否)
  #
  def ok?
    @response.success?
  end

end