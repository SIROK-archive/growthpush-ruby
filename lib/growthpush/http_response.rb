class HttpResponse

  #@header
  #@body
  #@response

  attr_reader :header
  attr_reader :body

  def initialize(response)
    @response = response
    @header = response.headers
    @body = response.body
  end

  def is_ok?
    @response.success?
  end

end