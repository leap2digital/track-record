module TrackRecord
  class Tracker
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
  
      TrackRecord::Client.index index: audit_index_name, body: body
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
      
      TrackRecord::Client.index index: audit_index_name, body: body
    end
  end
end
