# frozen_string_literal: true

class ApplicationController < ActionController::API

    include Authorization
    
    protected
  
    def render_error(message, status: :bad_request)
      Rails.logger.warn { message }
      render json: { errors: [{ detail: message }], status: status }, status: status
    end

end