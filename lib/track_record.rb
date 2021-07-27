require 'activesupport'
require 'elasticsearch/model'

module TrackRecord
  extend ActiveSupport::Concern

  QUERY_AMOUNT = ENV["FEED_EVENTS_QUERY_AMOUNT"].to_i || 100
  Client = Elasticsearch::Model.client

  included do
    after_commit on: :create do
      track_change(:index, self.class.to_s, id, previous_changes, current_user, "create")
    end

    after_commit on: :update do
      track_change(:index, self.class.to_s, id, previous_changes, current_user, "update")
    end

    around_destroy :audit_deleted
  end

  def audit_deleted
    record = self.to_json
    index_name = self.audit_index_name
    record_id = self.id
    yield
    track_deletion(self.class.to_s, record_id, current_user, "delete", record, index_name)
  end

  def audit_index_name
    Rails.env.production? ? "audit_#{model_name.route_key}" : "audit_#{model_name.route_key}_#{Rails.env}"
  end
  
  def current_user
    $custom_current_user.present? ? $custom_current_user.as_json : nil
  end

  def feed
    search_hash = Hash.new
    search = Client.search index: audit_index_name, ignore: [404], body: { size: QUERY_AMOUNT, query: { match: { 'record.id': id } } }
    search_hash[self.class.to_s] = search['hits']['hits'].pluck('_source') unless search['hits'].nil?
    association_class_list = self.association_classes
    search_hash = search_hash.merge(self.association_feed(association_class_list))
    search_hash = search_hash.merge(self.richtext_feed(association_class_list))
  end

  private

  def association_classes
    Rails.application.eager_load!
    ApplicationRecord.descendants.collect(&:name).select{ |model| model.constantize.reflect_on_all_associations().map(&:name).include? self.class.to_s.underscore.to_sym }
  end

  def association_feed(association_class_list)
    association_search_hash = Hash.new
    association_class_list.each do | association_class |
      instance = association_class.classify.constantize.new
      search = association_search(instance.audit_index_name, self.class.to_s.underscore)
      association_search_hash[association_class] = search unless search.nil?
    end
    association_search_hash
  end

  def association_search(index_name, parent_class_name)
    search = Client.search index: index_name, ignore: [404], body: { size: QUERY_AMOUNT, query: { match: { "record.#{parent_class_name}_id": id } } }
    search['hits']['hits'].pluck('_source') unless search['hits'].nil?
  end

  def richtext_feed(association_class_list)
    richtext_hash = Hash.new
    richtext_hash["RichText"] = Hash.new
    audit_index_name = Rails.env.production? ? "audit_richtext" : "audit_richtext_#{Rails.env}"
    search = richtext_search(audit_index_name, self.class.to_s)
    richtext_hash["RichText"][self.class.to_s] = search unless (search.nil? || search.empty?)
    association_class_list.each do | association_class |
      search = richtext_search(audit_index_name, association_class)
      richtext_hash["RichText"][association_class] = search unless (search.nil? || search.empty?)
    end
    richtext_hash
  end

  def richtext_search(index_name, class_name)
    search = Client.search index: index_name, ignore: [404], body: { size: QUERY_AMOUNT, query: { bool: { must: [ { match: { "record.record_id": id } }, 
                                                      { match: { "record.record_type": class_name } }]}}}
    search['hits']['hits'].pluck('_source') unless search['hits'].nil?
  end

  def track_change(operation, class_name, record_id, previous_changes, user, event_action)
    Rails.logger.debug [operation, "Model: #{class_name}; ID: #{record_id}; Changes: #{previous_changes}; User: #{user}"]
    return if previous_changes.empty?

    class_const = class_name.constantize
    record = class_const.find(record_id)
    body = {}
    body['event_action'] = event_action
    body['record'] = record.as_json
    body['changes'] = previous_changes
    body['user'] = user unless user.nil?

    if class_name == 'ActionText::RichText'
      audit_index_name = Rails.env.production? ? "audit_richtext" : "audit_richtext_#{Rails.env}"
    else
      audit_index_name = record.audit_index_name
    end

    Client.index index: audit_index_name, body: body
  end

  def track_deletion(class_name, record_id, user, event_action, deleted_record, index_name)
    Rails.logger.debug [event_action, "Model: #{class_name}; ID: #{record_id}; User: #{user}"]
    
    body = {}
    body['event_action'] = event_action
    body['record'] = JSON.parse(deleted_record)
    body['changes'] = { "updated_at" => [body['record']['updated_at'], DateTime.now.to_s] }
    body['user'] = user unless user.nil?
    
    if class_name == 'ActionText::RichText'
      audit_index_name = Rails.env.production? ? "audit_richtext_" : "audit_richtext_#{Rails.env}"
    else
      audit_index_name = index_name
    end
    
    Client.index index: audit_index_name, body: body
  end
end