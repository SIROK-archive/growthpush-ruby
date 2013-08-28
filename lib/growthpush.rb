require 'growthpush/version'
require 'growthpush/client'
require 'growthpush/event'
require 'growthpush/tag'
require 'growthpush/growth_push_exception'
require 'growthpush/http_client'
require 'growthpush/http_response'

class Growthpush
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

  def initialize(application_id, secret, environment= Growthpush::ENVIRONMENT_PRODUCTION)
    @application_id = application_id
    @secret = secret
    @environment = environment
  end

  def create_client(token, os)
    client = Client.new(token, os)
    @client = client
    return client.save(self)
  end

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
    @client = nil

    if !client.instance_of? Client
      client = Client.new(client)
    end

    event = Event.new(client, name, value)
    return event.save(self)
  end
  private :create_event_3

  def create_event_2(name, value = nil)
    return create_event_3(@client,name,value)
  end
  private :create_event_2

  def create_event_1(map={})
    if @client.nil?
      raise GrowthPushException.new('Client not found')
    end

    return create_event_2(map.keys[0].to_s, map.values[0])
  end
  private :create_event_1

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
    @client = nil

    if !client.instance_of? Client
      client = Client.new(client)
    end

    tag = Tag.new(client, name, value)
    return tag.save(self)
  end
  private :create_tag_3

  def create_tag_2(name, value=nil)
    return create_tag_3(@client, name, value)
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
