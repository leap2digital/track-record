require 'rails/generators'
module TrackRecord
  module Generators
    class ElasticsearchConfigGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __dir__)
      desc 'Creates an Elasticsearch Client config file.'
      def copy_config
        template 'elasticsearch_config.rb', "#{Rails.root}/config/initializers/elasticsearch.rb"
      end
    end
  end
end
