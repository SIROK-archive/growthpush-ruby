GrowthPush SDK for Ruby
==================

:rotating_light: **This SDK is no longer maintained** :rotating_light:  

GrowthPush is push notification and analysis platform for smart devices. GrowthPush SDK for Ruby provides registration function of client devices and events.

```shell
gem install growthpush
```

```ruby
require 'growth_push';

growth_push = GrowthPush.new(YOUR_APP_ID,'YOUR_APP_SECRET')
client = growth_push.create_client('DEVICE_TOKEN','ios')
```

## Track events and tags.

If you want to track events of client devices, the following code are useful.

```ruby
event = growth_push.create_event('DEVICE_TOKEN', 'Launch')
```

You can tag the devices.

```ruby
tag = growth_push.create_tag('DEVICE_TOKEN', 'Gender', 'male')
```

That's all. Client devices can be browsed with dashboard. You can send push notifications to the devices and analyze the events.

## License

Licensed under the Apache License.
