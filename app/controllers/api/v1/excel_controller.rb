# frozen_string_literal: true

class Api::V1::ExcelController < ApplicationController
  before_action :authenticate_user!

  include ActionController::MimeResponds
    
  def download
    records = related ?
      instance.send(related)
      : klass_search_scope.where(between_times_filter).where(allowed_filter)
    send_data(records.to_xlsx)
  rescue StandardError => e
    render_error e.message
  end

  def upload
    args = {
        partial: ActiveModel::Type::Boolean.new.cast(params[:partial]),
        file: uploaded_file_path,
        resource: params[:resource],
        unique_key: params[:unique_key],
    }         
  if ActiveModel::Type::Boolean.new.cast(params[:delayed])
    if ExcelUploaderJob.perform_later(args)
        render json: { 
            message: 'Rows are being imported..',
        }, status: :ok
    else             
      render_error "Error starting job"
    end
  else
    begin
      uploader = ExcelUploader::Default.new(args)
      if uploader.save
        render json: { 
            message: "Rows have been imported", 
        }, status: :ok
      else
        render_error "#{uploader.errors.count} errors prevented us from importing your spreadsheet. 
        Please update your spreadsheet and try again. 
        #{uploader.errors.full_messages.join(', ')}"
      end
    rescue => e
      render_error e.message
    end            
  end
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
    filter.except(:q).except(:updated_at_geq).except(:updated_at_leq)    
  end

  def between_times_filter
    params[:resource] == ('countries') ?
    { updated_at: Chronic.parse(filter[:updated_at_geq])..Chronic.parse(filter[:updated_at_leq]) }
    : "1=1"
  end 

  def uploaded_file_path(file=params[:file])
    file_path = File.join("tmp", 
                          file.original_filename)
    File.open(file_path, "wb"){ |f| f.write(IO.read file.tempfile.path) }
    file_path     
  end     

end
