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

  def ok?
    @response.success?
  end

end