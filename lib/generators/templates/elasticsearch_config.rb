# frozen_string_literal: true

require 'elasticsearch/model'

Elasticsearch::Model.client = Elasticsearch::Client.new(
  url: (ENV['ELASTICSEARCH_URL'] || 'http://localhost:9200'),
  retry_on_failure: true,
  transport_options: { request: { timeout: 250 } }
)
