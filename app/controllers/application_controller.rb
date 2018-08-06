# frozen_string_literal: true

class ApplicationController < ActionController::API

    include Authorization

    def not_found
        render_error 'Page not found', 404
    end      

    protected
  
    def render_error(message, status = :bad_request)
        Rails.logger.warn { message }
        render json: { errors: [{ detail: message }] }, status: status 
    end

end