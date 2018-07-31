# frozen_string_literal: true

module Authorization
    extend ActiveSupport::Concern
  
    included do
      attr_reader :current_user,
                  :current_token
  
      rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
    end
  
    def authenticate_user!
      if has_authorization?
        if jwt_claims && jwt_claims['username'] && (user = User.find_in_cache(jwt_claims['username'], token))
          if valid_authenticity_token?(user)
            @current_user = user
            @current_token = token
          else
            render json: { errors: [{ detail: 'Invalid authorization token' }] }, status: :unauthorized
          end
        else
          render json: { errors: [{ detail: 'Invalid credentials' }] }, status: :unauthorized
          end
      else
        render json: { errors: [{ detail: 'No authorization credentials received' }] }, status: :bad_request
      end
    end
  
    private
  
    def authorization_headers
      request.headers['Authorization']
    end
  
    def token
      authorization_headers.split(' ').second
    end
  
    def valid_authenticity_token?(user)
      user.has_valid_token?(token)
    end
  
    def has_authorization?
      authorization_headers.present? &&
        authorization_headers.split(' ').size == 2 &&
        authorization_headers.split(' ').first == 'Bearer'
      end
  
    def jwt_claims
      JsonWebToken.new.decode(token)
    rescue StandardError
      nil
    end
  
    def user_not_authorized
      head :forbidden
    end
  end
  