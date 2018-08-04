# frozen_string_literal: true

class Api::V1::ExcelController < ApplicationController
    before_action :authenticate_user!
  
    include ActionController::MimeResponds
      
    def download
      records = related ?
        instance.send(related)
        : klass_search_scope.where(allowed_filter)
      send_data(records.to_xlsx)
    rescue StandardError => e
      render_error e.message
    end
  
    private

    # params[:resource] the model name we want to download records from
    def klass
      params[:resource].tableize.singularize.camelize.constantize
    end
  
    # filter[:q] is a free-text search
    def klass_search_scope
      filter[:q].present? ?
        klass.search(filter[:q])
        : klass.all
    end
  
    # params[:related] controls whether to send
    # false: noop
    # true: all records related to the id of the object received
    # ex. all posts of a certain author
    def related
      params[:related] ?
        params[:related].tableize : nil
    end
  
    # params[:id] required when requesting related records
    def instance
      params[:id] ?
        klass.find(params[:id])
        : nil
    end
   
    # params[:filter] filters applied to the search records
    def filter
      params[:filter] && params[:filter].permit! || {}
    end
  
    def allowed_filter
      filter.except(:q)
    end  
  
  end
  