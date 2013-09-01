require 'digest/sha2'
require 'spec_helper'
require 'growth_push'

APPLICATION_ID = 128
SECRET = 'FUAOPniE3pGTczjU7kUkzbY2j2K1SU5S'
TOKEN = '2ffaa8b5eb147c0ebc3ecb0824315d683be40a8bb7aca6aa6fced34c008092ae'
CLIENT_ID = 763605

describe "Growthpush" do

  growth_push = nil
  growth_push2 = nil
  client = nil
  token = nil
  event = nil
  tag = nil

  before(:all) do
    growth_push = GrowthPush.new(APPLICATION_ID, SECRET)
  end

  describe "initialize" do
    it 'test' do
      growth_push.application_id.should == APPLICATION_ID
      growth_push.secret.should == SECRET
      growth_push.environment.should == GrowthPush::ENVIRONMENT_PRODUCTION
    end
  end

  describe 'create_client' do
    before(:all) do
      token = Digest::SHA256.hexdigest(Random.rand.to_s)
      client = growth_push.create_client(token, GrowthPush::OS_IOS)
    end

    it 'test' do
      (client.id > 0).should be_true
      client.token.should == token
    end
  end

  describe 'create client with duplicate token' do
    before(:all) do
      client = growth_push.create_client(TOKEN, GrowthPush::OS_IOS)
    end

    it 'test' do
      client.id.should == CLIENT_ID
    end
  end

  describe 'create client with bad token' do

    it 'test' do
      proc{ growth_push.create_client('bad_token', GrowthPush::OS_IOS) }.should raise_error
    end

  end

  describe 'create client with bad os' do
    it 'test' do
      proc{ growth_push.create_client(TOKEN, 'bad_os') }.should raise_error
    end
  end

  describe 'create event (using token)' do
    before(:all) do
      event = growth_push.create_event(TOKEN,'Launch', '')
    end

    it 'test' do
      (event.goal_id > 0).should be_true
      (event.timestamp > 0).should be_true
      (event.client_id > 0).should be_true
    end
  end

  describe 'create event (with client)' do
    before(:all) do
      client = growth_push.create_client(TOKEN, GrowthPush::OS_IOS)
      event = growth_push.create_event(client,'Launch', '')
    end

    it 'test' do
      (event.goal_id > 0).should be_true
      (event.timestamp > 0).should be_true
      (event.client_id > 0).should be_true
    end
  end

  describe 'create event (with client) using name & value' do
    before(:all) do
      growth_push.create_client(TOKEN, GrowthPush::OS_IOS)
      event = growth_push.create_event('Launch', '')
    end

    it 'test' do
      (event.goal_id > 0).should be_true
      (event.timestamp > 0).should be_true
      (event.client_id > 0).should be_true
    end
  end

  describe 'create event (with client) using hash (name => value)' do
    before(:all) do
      growth_push.create_client(TOKEN, GrowthPush::OS_IOS)
      event = growth_push.create_event('Launch' => '')
    end

    it 'test' do
      (event.goal_id > 0).should be_true
      (event.timestamp > 0).should be_true
      (event.client_id > 0).should be_true
    end
  end

  describe 'create event without client using name & value' do
    before(:all) do
      growth_push2 = GrowthPush.new(APPLICATION_ID, SECRET)
    end

    it 'test' do
      proc{ growth_push2.create_event('Launch', '') }.should raise_error
    end
  end

  describe 'create event without client using hash (name => value)' do
    before(:all) do
      growth_push2 = GrowthPush.new(APPLICATION_ID, SECRET)
    end

    it 'test' do
      proc{ growth_push2.create_event('Launch' => '') }.should raise_error
    end
  end

  describe 'create event with empty name (using token)' do
    before(:all) do
      growth_push2 = GrowthPush.new(APPLICATION_ID, SECRET)
    end

    it 'test' do
      proc{ growth_push2.create_event(TOKEN, '') }.should raise_error
    end
  end

  describe 'create event with empty name (with client)' do
    before(:all) do
      client = growth_push.create_client(TOKEN, GrowthPush::OS_IOS)
    end

    it 'test' do
      proc{ growth_push.create_event(client, '') }.should raise_error
    end
  end

  describe 'create event with long name (using token)' do
    before(:all) do
      growth_push2 = GrowthPush.new(APPLICATION_ID, SECRET)
    end

    it 'test' do
      proc{ growth_push2.create_event(TOKEN, 'long' * 100) }.should raise_error
    end
  end

  describe 'create event with long name (with client)' do
    before(:all) do
      client = growth_push.create_client(TOKEN, GrowthPush::OS_IOS)
    end

    it 'test' do
      proc{ growth_push.create_event(client, 'long' * 100) }.should raise_error
    end
  end

  describe 'create tag (using token)' do
    before(:all) do
      tag = growth_push.create_tag(TOKEN, 'Gender', 'male')
    end

    it 'test' do
      (tag.tag_id > 0).should be_true
      (tag.client_id > 0).should be_true
      tag.value.should == 'male'
    end
  end

  describe 'create tag (with client)' do
    before(:all) do
      client = growth_push.create_client(TOKEN, GrowthPush::OS_IOS)
      tag = growth_push.create_tag(client, 'Gender', 'male')
    end

    it 'test' do
      (tag.tag_id > 0).should be_true
      (tag.client_id > 0).should be_true
      tag.value.should == 'male'
    end
  end

  describe 'create tag (with client) using name & value' do
    before(:all) do
      growth_push.create_client(TOKEN, GrowthPush::OS_IOS)
      tag = growth_push.create_tag('Gender', 'male')
    end

    it 'test' do
      (tag.tag_id > 0).should be_true
      (tag.client_id > 0).should be_true
      tag.value.should == 'male'
    end
  end

  describe 'create tag (with client) using hash (name => value)' do
    before(:all) do
      growth_push.create_client(TOKEN, GrowthPush::OS_IOS)
      tag = growth_push.create_tag('Gender' => 'male')
    end

    it 'test' do
      (tag.tag_id > 0).should be_true
      (tag.client_id > 0).should be_true
      tag.value.should == 'male'
    end
  end

  describe 'create tag without client using name & value' do
    before(:all) do
      growth_push2 = GrowthPush.new(APPLICATION_ID, SECRET)
    end

    it 'test' do
      proc{ growth_push2.create_tag('Gender', 'male') }.should raise_error
    end
  end

  describe 'create tag without client using hash (name => value)' do
    before(:all) do
      growth_push2 = GrowthPush.new(APPLICATION_ID, SECRET)
    end

    it 'test' do
      proc{ growth_push2.create_tag('Gender' => 'male') }.should raise_error
    end
  end

  describe 'create tag with empty name (using token)' do
    before(:all) do
      growth_push2 = GrowthPush.new(APPLICATION_ID, SECRET)
    end

    it 'test' do
      proc{ growth_push2.create_tag(TOKEN, '') }.should raise_error
    end
  end

  describe 'create tag with empty name (with client)' do
    before(:all) do
      client = growth_push.create_client(TOKEN, GrowthPush::OS_IOS)
    end

    it 'test' do
      proc{ growth_push.create_tag(client, '') }.should raise_error
    end
  end

  describe 'create tag with long name (using token)' do
    before(:all) do
      growth_push2 = GrowthPush.new(APPLICATION_ID, SECRET)
    end

    it 'test' do
      proc{ growth_push2.create_tag(TOKEN, 'long' * 100) }.should raise_error
    end
  end

  describe 'create tag with long name (with client)' do
    before(:all) do
      client = growth_push.create_client(TOKEN, GrowthPush::OS_IOS)
    end

    it 'test' do
      proc{ growth_push.create_tag(client, 'long' * 100) }.should raise_error
    end
  end

end

