class Tag

  #@name
  #@tag_id
  #@client_id
  #@value
  #@client

  attr_reader :name
  attr_reader :id
  attr_reader :client_id
  attr_reader :value

  alias_method :tag_id, :id

  def initialize(client,name,value=nil)
    @client = client
    @name = name
    @value = value
  end

  def save(growth_push)
    begin
      if @client.id && @client.code
        http_response = HttpClient.instance.post('tags',
                                                     {
                                                         'clientId' => @client.id,
                                                         'code' => @client.code,
                                                         'name' => self.name,
                                                         'value' => self.value
                                                     }
        )
      elsif @client.token
        http_response = HttpClient.instance.post('tags',
                                                     {
                                                         'applicationId' => growth_push.application_id,
                                                         'secret' => growth_push.secret,
                                                         'token' => @client.token,
                                                         'name' => self.name,
                                                         'value' => self.value,
                                                     }
        )
      else
        raise GrowthPushException.new('Invalid client')
      end

    rescue GrowthPushException => ex
      raise GrowthPushException.new('Failed to save tag: ' << ex.message, ex.code)
    end

    body = http_response.body
    self.attributes = body

    return self
  end

  def attributes=(attributes)
    @id = attributes['tagId'];
    @client_id = attributes['clientId'];
    @value = attributes['value'];
  end
  private :attributes=

end