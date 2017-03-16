class Api::V1::ApiController < ActionController::API
  	
	include Pundit
	include FlexiblePermissions
	include ActiveHashRelation
    #requires monkeyparched scopes, optional if you don't enable them
    ActiveHashRelation.initialize! 	
	include HttpAcceptLanguage::AutoLocale 					 
	include DeviseTokenAuth::Concerns::SetUserByToken
	
    before_action :authenticate_api_user!, except: :options  
    
    rescue_from ActiveRecord::RecordNotFound do
      api_error status: :not_found, 
                errors: I18n.t('errors.messages.not_found')     	
    end
      	        
    rescue_from ActionController::ParameterMissing do
      api_error status: :bad_request, 
                errors: I18n.t('errors.messages.parameters_missing')
    end 
    
    rescue_from Pundit::NotAuthorizedError do
      unless Rails.env.production? || Rails.env.test?
        Rails.logger.warn { "Unauthorized user: #{current_api_user.try(:id)}" }
      end
      api_error status: :forbidden, 
                errors: I18n.t('errors.messages.not_authorized')
    end 
     
    before_action do
      self.namespace_for_serializer = Api::V1
    end    
    
    def options
      return head :ok
    end  
  
    protected
    
    def invalid_request!
        api_error status: :bad_request,
     	          errors:  I18n.t('errors.messages.bad_request')
    end 
    
    def current_user
    	current_api_user
    end
    
    def paginate(resource)
      resource = resource.page(params[:page] || 1)
      resource = resource.per(params[:per_page]) if params[:per_page]      
      return resource      
    end
    
    def search(resource)
    	apply_filters(!params[:q] || params[:q].empty? ? resource.all : resource.search(params[:q]), JSON.parse(params[:filters]))
    end    

    # expects paginated resource!
    def meta_attributes(resource, extra_meta = {})
      meta = {
        current_page: resource.current_page,
        next_page: resource.next_page,
        prev_page: resource.prev_page,
        total_pages: resource.total_pages,
        total_count: resource.total_count
      }.merge(extra_meta)

      return meta
    end   
    
    def invalid_resource!(errors = [])
      api_error status: :unprocessable_entity, 
                errors: errors
    end
    
    def api_error(status: :internal_server_error, errors: [])
      puts errors.full_messages if errors.respond_to?(:full_messages)
      render json: Api::V1::ErrorSerializer.new(api_error_symbol_to_status_code(status), errors).as_json,
             status: status
    end      
    
    def api_error_symbol_to_status_code(status)
    	Rack::Utils::SYMBOL_TO_STATUS_CODE[status]
    end
    
end