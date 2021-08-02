# Track Record

This is a gemified plugin for Ruby on Rails applications that also use ElasticSearch as part of their stack. This gem adds change tracking features to the Rails app models, so that setting up an activity feed for that model (or more models) becomes easier.

It is based on ActiveRecord callbacks. As the record is created, updated or deleted, its changes and also its associated records' data are stored in an ElasticSearch index.

## Requirements

This gem was created with Ruby 2.7, Rails 6.0.3 and ElasticSearch 7.7. Forwards and backwards compatibility is at this stage unknown.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'track-record'
```

And then execute:

```bash
$ bundle
```

Or install it yourself as:

```bash
$ gem install track-record
```

### Configuring an Elasticsearch client for TrackRecord

You can use the generator below to create an initializer for ElasticSearch client config:

```bash
$ rails generate track_record:elasticsearch_config
```

NOTE: You can find an example of a [docker-compose.yml](https://github.com/leap2digital/track-record/blob/main/docker-compose.yml) we use for the gem's development with Ruby and Elasticsearch, this might help you set up a development environment.

## Usage

To start tracking changes in your Rails models simply require the gem's module and include it in your model.rb:

```ruby
require 'track-record'

class YourModel < ApplicationRecord
  include TrackRecord

  # Your model code
end
```

### Tracking the user who made modifications to your model

To track who made modifications to the model we use a global variable called $custom_current_user. You can set the authenticated user to this variable in your authentication logic and the gem will include its info on the changes track record.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/leap2digital/track-record.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
