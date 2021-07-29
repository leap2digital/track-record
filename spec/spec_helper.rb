Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].sort.each { |f| require f }

ENV['RAILS_ENV'] = 'test'

require_relative '../spec/dummy/config/environment'
ENV['RAILS_ROOT'] ||= "#{File.dirname(__FILE__)}../../../spec/dummy"

require 'track_record'
require 'rspec/rails'

require 'elasticsearch/model'
Elasticsearch::Model.client = Elasticsearch::Client.new(
  url: (ENV['ELASTICSEARCH_URL'] || 'http://elasticsearch:9200'),
  retry_on_failure: true,
  transport_options: { request: { timeout: 250 } }
)

RSpec.configure do |config|
  config.include FileManager
end
