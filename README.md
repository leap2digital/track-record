# Track Record

This is a gemified plugin for Ruby on Rails applications that also use ElasticSearch as part of their stack. This gem adds change tracking features to the Rails app models, so that setting up an event activity feed for that model (or more models) becomes easier.

It is based on ActiveRecord callbacks. As the record is created, updated or deleted, its changes and also its associated records' data are stored in an ElasticSearch index.

## Requirements

This gem requires Ruby 2.7+, Rails 6.0+ and ElasticSearch 7.7+.

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

You can use the generator below to create an initializer for Elasticsearch client config:

```bash
rails generate track_record:elasticsearch_config
```

### Tracking the user who made modifications to your model

To track who made modifications to the model we use a global variable called $custom_current_user. You can set the authenticated user to this variable in your authentication logic and the gem will include its info on the changes track record.

## Usage

To start tracking changes in your Rails models simply include the module in your model.rb:

```ruby
include TrackRecord
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/leap2digital/track-record.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
