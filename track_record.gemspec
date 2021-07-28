# frozen_string_literal: true

require File.expand_path('lib/track_record/version', __dir__)

Gem::Specification.new do |spec|
  spec.name          = 'track-record'
  spec.version       = TrackRecord::VERSION
  spec.authors       = ['Lucas Vidal']
  spec.email         = ['lcv55@hotmail.com']
  spec.summary       = 'Add change tracking to your models in Rails'
  spec.description   = 'This gem helps you track changes to your Rails models using ElasticSearch.'
  spec.homepage      = 'https://github.com/leap2digital/track-record'
  spec.license       = 'MIT'
  spec.platform      = Gem::Platform::RUBY
  spec.required_ruby_version = '>= 2.7.0'
  spec.files = Dir['README.md', 'LICENSE', 'CHANGELOG.md', 'lib/**/*.rb', 'track_record.gemspec', 'Gemfile', 'Rakefile']

  spec.add_development_dependency 'rubocop', '~> 0.60'
  spec.add_development_dependency 'rubocop-performance', '~> 1.5'
  spec.add_development_dependency 'rubocop-rspec', '~> 1.37'
  spec.add_development_dependency 'rails', '~> 6.0.3'
  spec.add_development_dependency 'rspec', '~> 3.6'
  spec.add_development_dependency 'rspec-rails', '~> 4.0'
  spec.add_development_dependency 'sqlite3', '~> 1.4'

  spec.add_dependency 'activesupport', '~> 6.0.3'
  spec.add_dependency 'elasticsearch-model', '~> 7.0'
end
