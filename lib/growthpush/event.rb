#
# Event Class (イベント クラス)
#
class Event

  #@name = nil
  #@goal_id = nil
  #@timestamp = nil
  #@client_id = nil
  #@value = nil
  #@client = nil

  attr_reader :name
  attr_reader :goal_id
  attr_reader :timestamp
  attr_reader :client_id
  attr_reader :value

  #
  # initializer (イニシャライザ)
  # @param [Client] client Client object (クライアント)
  # @param [String] name event name (イベント名)
  # @param [String] value optional info of event (イベントの追加情報)
  #
  def initialize(client, name, value=nil)
    @client = client
    @name = name
    @value = value
  end

  #
  # save event (イベントを登録する)
  # @param [GrowthPush] growth_push GrowthPush object (GrowthPushオブジェクト)
  # @raise [GrowthPushException] exception (例外)
  # @return [Event] event (イベント)
  #
  def save(growth_push)
    begin
      if @client.id && @client.code
        http_response = HttpClient.instance.post('events',
                                                     {
                                                         'clientId' => @client.id,
                                                         'code' => @client.code,
                                                         'name' => self.name,
                                                         'value' => self.value
                                                     }
        )
      elsif @client.token
        http_response = HttpClient.instance.post('events',
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
      raise GrowthPushException.new('Failed to save event: ' << ex.message, ex.code)
    end

    body = http_response.body
    self.attributes = body

    return self
  end

  #
  # set attributes (属性をセットする)
  # @param [Hash] attributes attributes (属性)
  #
  def attributes=(attributes)
    @goal_id = attributes['goalId'];
    @timestamp = attributes['timestamp'];
    @client_id = attributes['clientId'];
    @value = attributes['value'];
  end
  private :attributes=

end