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
    return client.save(self)
  end

  def create_event(client, name, value=nil)
    if client.instance_of? Client
      client = Client.new(client)
    end

    event = Event.new(client, name, value)
    return event.save(self)
  end

  def create_tag(client, name, value=nil)
    if client.instance_of? Client
      client = Client.new(client)
    end

    tag = Tag.new(client, name, value)
    return tag.save(self)
  end

end
