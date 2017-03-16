class Api::V1::ApiSerializer < ActiveModel::Serializer
	
  include Rails.application.routes.url_helpers
  
  def created_at
    object.created_at.to_datetime.in_time_zone('UTC').iso8601 if object.created_at
  end

  def updated_at
    object.updated_at.to_datetime.in_time_zone('UTC').iso8601 if object.updated_at
  end
  
end  