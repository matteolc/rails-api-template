# frozen_string_literal: true

class Api::V1::RegistrationsController < ApplicationController
    
    before_action :authenticate_user!, except: :create

    def create
        @account = Account.new(registration_params)
        if @account.save
          render json: @account, status: :ok
        else
          render_error "There was a problem processing your request"
        end
    end

    def destroy; end
    
    private
    
    def registration_params
      params.permit(:email, :username, :password, :password_confirmation)
    end   

end