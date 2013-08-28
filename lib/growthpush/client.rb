class Client

  #@id = nil
  #@application_id = nil
  #@code = nil
  #@token = nil
  #@os = nil
  #@environment = nil
  #@status = nil
  #@created = nil

  attr_reader :id
  attr_reader :application_id
  attr_reader :code
  attr_reader :token
  attr_reader :os
  attr_reader :environment
  attr_reader :status
  attr_reader :created

  def initialize(token, os=nil)
    @token = token
    @os = os
  end

  def save(growth_push)

    begin
      http_response = HttpClient.instance.post('clients',
                                                   {
                                                       'applicationId' => growth_push.application_id,
                                                       'secret' => growth_push.secret,
                                                       'token' => self.token,
                                                       'os' => self.os,
                                                       'environment' => growth_push.environment
                                                   }
      )
    rescue GrowthPushException => ex
      raise GrowthPushException.new('Failed to save client: ' << ex.message, ex.code)
    end

    self.attributes = http_response.body

    return self
  end

  def attributes=(attributes)
    @id = attributes['id']
    @application_id = attributes['applicationId']
    @code = attributes['code']
    @token = attributes['token']
    @os = attributes['os']
    @environment = attributes['environment']
    @status = attributes['status']
    @created = attributes['created']
  end
  private :attributes=

end