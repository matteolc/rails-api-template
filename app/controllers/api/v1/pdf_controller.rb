# frozen_string_literal: true

class Api::V1::PdfController < ApplicationController
    before_action :authenticate_user!
  
    include ActionController::MimeResponds
  
    def print
      send_file(
          instance.to_pdf, 
          filename: instance.name, 
          type: :pdf )
    rescue StandardError => e
      render_error e.message
    end

    private
  
    def klass
      params[:resource].singularize.camelize.constantize
    end

    def instance
      klass.find(params[:id])
    end
  
end