# frozen_string_literal: true

class Api::V1::ApiController < ApplicationController
  include JSONAPI::ActsAsResourceController        
  before_action :authenticate_user!     
  
  private

  def context
    { user: current_user,
      action: action_name }
  end

end