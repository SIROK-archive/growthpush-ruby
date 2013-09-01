#
# HTTP Response Class (HTTPレスポンス クラス)
#
class HttpResponse

  #@header
  #@body
  #@response

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