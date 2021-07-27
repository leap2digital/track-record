# Track Record

This is a gemified plugin for Ruby on Rails applications that also use ElasticSearch as part of their stack. This gem adds change tracking features to the Rails app models, so that setting up an event activity feed for that model (or more models) becomes easier.

It is based on ActiveRecord callbacks. As the record is created, updated or deleted, its changes and also its associated records' data are stored in an ElasticSearch index.

## Requirements

This gem uses Ruby 2.7+, Rails 6.0+ and ElasticSearch 7.7+.

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

## Usage

To start tracking changes in your Rails models simply include the module in your model.rb:

```ruby
include TrackRecord
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/leap2digital/track-record.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
