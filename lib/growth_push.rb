require 'growthpush/version'
require 'growthpush/client'
require 'growthpush/event'
require 'growthpush/tag'
require 'growthpush/growth_push_exception'
require 'growthpush/http_client'
require 'growthpush/http_response'

#
# GrowthPush Class (GrowthPush クラス)
#
class GrowthPush
  OS_IOS = 'ios';
  OS_ANDROID = 'android';

  ENVIRONMENT_PRODUCTION = 'production';
  ENVIRONMENT_DEVELOPMENT = 'development';

  #@application_id = nil
  #@secret = nil
  #@environment = nil
  #@client = nil

  attr_reader :application_id
  attr_reader :secret
  attr_reader  :environment

  #
  # initializer (イニシャライザ)
  # @param [Integer] application_id application id (アプリID)
  # @param [String] secret secret key (アプリのシークレットキー)
  # @param [String] environment environment (環境設定)
  #
  def initialize(application_id, secret, environment= GrowthPush::ENVIRONMENT_PRODUCTION)
    @application_id = application_id
    @secret = secret
    @environment = environment
  end

  #
  # create client (クライアントを作成する)
  # @param [String] token device token (デバイス・トークン)
  # @param [String] os os name (OS名)
  # @return [Client] client object (クライアント)
  #
  def create_client(token, os)
    client = Client.new(token, os)
    @client = client
    return client.save(self)
  end

  #
  # create event (イベントを作成する)
  # @overload create_event(name)
  #  @param [String] name event name (イベント名)
  #  @raise [GrowthPushException] exception (例外)
  #  @return [Event] event (イベント)
  # @overload create_event(map)
  #  @param [Hash] map event hash (イベントのハッシュ)
  # @overload create_event(name, value)
  #  @param [String] name event name (イベント名)
  #  @param [String] value optional info of event (イベントの追加情報)
  #  @raise [GrowthPushException] exception (例外)
  #  @return [Event] event (イベント)
  # @overload create_event(token, name)
  #  @param [String] token device token (デバイス・トークン)
  #  @param [String] name event name (イベント名)
  #  @raise [GrowthPushException] exception (例外)
  #  @return [Event] event (イベント)
  # @overload create_event(client, name)
  #  @param [Client] client Client object (クライアント)
  #  @param [String] name event name (イベント名)
  #  @raise [GrowthPushException] exception (例外)
  #  @return [Event] event (イベント)
  # @overload create_event(token, name, value)
  #  @param [String] token device token (デバイス・トークン)
  #  @param [String] name event name (イベント名)
  #  @param [String] value optional info of event (イベントの追加情報)
  #  @raise [GrowthPushException]exception (例外)
  #  @return [Event] event (イベント)
  # @overload create_event(client, name, value)
  #  @param [Client] client Client object (クライアント)
  #  @param [String] name event name (イベント名)
  #  @param [String] value optional info of event (イベントの追加情報)
  #  @raise [GrowthPushException] exception (例外)
  #  @return [Event] event (イベント)
  #
  def create_event(*args)
    case args.length
      when 1
        if args[0].kind_of? Hash
          create_event_1(args[0])
        else
          create_event_2(args[0])
        end
      when 2
        if args[0].kind_of? String
          if !@client.nil?
            create_event_2(args[0],args[1])
          else
            create_event_3(args[0],args[1])
          end
        elsif args[0].kind_of? Client
          create_event_3(args[0],args[1])
        else
          raise ArgumentError
        end
      when 3
        create_event_3(args[0],args[1],args[2])
      else
        raise ArgumentError
    end
  end

  def create_event_3(client, name, value=nil)

    if !client.instance_of? Client
      client = Client.new(client)
    end

    @client = client

    return create_event_2(name, value)
  end
  private :create_event_3

  def create_event_2(name, value = nil)
    event = Event.new(@client, name, value)
    return event.save(self)
  end
  private :create_event_2

  def create_event_1(map={})
    if @client.nil?
      raise GrowthPushException.new('Client not found')
    end

    return create_event_2(map.keys[0].to_s, map.values[0])
  end
  private :create_event_1

  #
  # create tag (タグを作成する)
  # @overload create_tag(name)
  #  @param [String] name tag name (タグ名)
  #  @raise [GrowthPushException] exception (例外)
  #  @return [Tag] tag (タグ)
  # @overload create_tag(map)
  #  @param [Hash] map tag hash (タグのハッシュ)
  # @overload create_tag(name, value)
  #  @param [String] name tag name (タグ名)
  #  @param [String] value tag value (タグの値)
  #  @raise [GrowthPushException] exception (例外)
  #  @return [Tag] tag (タグ)
  # @overload create_tag(token, name)
  #  @param [String] token device token (デバイス・トークン)
  #  @param [String] name tag name (タグ名)
  #  @raise [GrowthPushException] exception (例外)
  #  @return [Tag] tag (タグ)
  # @overload create_tag(client, name)
  #  @param [Client] client Client object (クライアント)
  #  @param [String] name tag name (タグ名)
  #  @raise [GrowthPushException] exception (例外)
  #  @return [Tag] tag (タグ)
  # @overload create_tag(token, name, value)
  #  @param [String] token device token (デバイス・トークン)
  #  @param [String] name tag name (タグ名)
  #  @param [String] value tag value (タグの値)
  #  @raise [GrowthPushException] exception (例外)
  #  @return [Tag] tag (タグ)
  # @overload create_tag(client, name, value)
  #  @param [Client] client Client object (クライアント)
  #  @param [String] name tag name (タグ名)
  #  @param [String] value value (タグの値)
  #  @raise [GrowthPushException] exception (例外)
  #  @return [Tag] tag (タグ)
  #
  def create_tag(*args)
    case args.length
      when 1
        if args[0].kind_of? Hash
          create_tag_1(args[0])
        else
          create_tag_2(args[0])
        end
      when 2
        if args[0].kind_of? String
          if !@client.nil?
            create_tag_2(args[0],args[1])
          else
            create_tag_3(args[0],args[1])
          end
        elsif args[0].kind_of? Client
          create_tag_3(args[0],args[1])
        else
          raise ArgumentError
        end
      when 3
        create_tag_3(args[0],args[1],args[2])
      else
        raise ArgumentError
    end
  end

  def create_tag_3(client, name, value=nil)

    if !client.instance_of? Client
      client = Client.new(client)
    end

    @client = client

    return create_tag_2(name, value)
  end
  private :create_tag_3

  def create_tag_2(name, value=nil)
    tag = Tag.new(@client, name, value)
    return tag.save(self)
  end
  private :create_tag_2

  def create_tag_1(map={})
    if @client.nil?
      raise GrowthPushException.new('Client not found')
    end

    return create_tag_2(map.keys[0].to_s, map.values[0])
  end
  private :create_tag_1

end
