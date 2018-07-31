# frozen_string_literal: true

class Api::V1::SessionsController < ApplicationController
    before_action :authenticate_user!, only: :destroy
  
    def create
      user = User.find_by_username(params[:username])
      if user&.authenticate(params[:password]) && (token = user.generate_token)
        render json: { token: token }, status: :ok
      else
        render_error 'Wrong username or password', :unauthorized
      end
    end
  
    def destroy
      if @current_user.revoke_token(@current_token)
        render json: :ok, status: :ok
      else
        render_error 'An unexpected error occurred'
      end
    end
  end
  