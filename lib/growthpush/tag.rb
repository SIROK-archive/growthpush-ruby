#
# Tag Class (タグクラス)
#
# @version 0.1.0
# @!attribute [r] name
#  @return [String] tag name (タグ名)
# @!attribute [r] id
#  @return [String] tag id (タグID)
# @!attribute [r] client_id
#  @return [String] client id (クライアントID)
# @!attribute [r] value
#  @return [String] tag value (タグの値)
#
class Tag

  attr_reader :name
  attr_reader :id
  attr_reader :client_id
  attr_reader :value

  alias_method :tag_id, :id

  #
  # initializer (イニシャライザ)
  # @param [Client] client client object (クライント)
  # @param [String] name tag name (タグ名)
  # @param [String] value value (タグの値)
  #
  def initialize(client,name,value=nil)
    @client = client
    @name = name
    @value = value
  end

  #
  # save tag (タグを登録する)
  # @param [GrowthPush] growth_push GrowthPush object (GrowthPushオブジェクト)
  # @raise [GrowthPushException] exception (例外)
  # @return [Tag] tag (タグ)
  #
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

  #
  # set attributes (属性をセットする)
  # @param [Hash] attributes attributes (属性)
  #
  def attributes=(attributes)
    @id = attributes['tagId'];
    @client_id = attributes['clientId'];
    @value = attributes['value'];
  end
  private :attributes=

end