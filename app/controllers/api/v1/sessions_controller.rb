class Api::V1::SessionsController < ApplicationController
    
    before_action :authenticate_user!, only: :destroy

    def create
        user = User.find_by_username(params[:username])
        if user && user.authenticate(params[:password]) && (token = user.generate_token)
        render json: { token: token }, status: :ok
        else
        render json: { errors: [{status: :unauthorized, title: 'Authentication Error', detail: "Wrong username or password" }]}, status: :unauthorized
        end
    end

    def destroy
        if @current_user.revoke_token(@current_token)
            render json: :ok, status: :ok
        else
            render json: { errors: [{status: :bad_request, title: 'Authentication Error', detail: "An unexpected error occurred" }]}, status: :bad_request
        end            
    end

end