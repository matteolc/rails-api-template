module Api::V1
  class UsersController < ApiController
  	  
    before_action :load_resource
    
    # GET /users
    def index 
    	auth_users = policy_scope @users
        render jsonapi: auth_users.collection, 
               each_serializer: UserSerializer,
               fields: { user: auth_users.fields(params[:fields]) },
               meta: meta_attributes(auth_users.collection)
    end
    
    # GET /users/1
    def show
      auth_user = authorize_with_permissions @user
      render jsonapi: auth_user.record, 
             serializer: UserSerializer,
             fields: { user: auth_user.fields }
    end
        
    # POST /users
    def create
      auth_user = authorize_with_permissions @user      
      if (@user.save && update_roles!)
        render jsonapi: auth_user.record,
               serializer: UserSerializer,
               fields: { user: auth_user.fields },
               status: :created
      else
        invalid_resource! @user.errors
      end
    end
    
    # PATCH/PUT /users/1
    def update
      auth_user = authorize_with_permissions(@user, :update?)      
      if (@user.update(update_params) && update_roles!)      	
        render jsonapi: auth_user.record,
               serializer: UserSerializer,
               user: { user: auth_user.fields }
      else
        invalid_resource! @user.errors
      end    	
    end
    
    # DELETE /users/1
    def destroy
      auth_user = authorize_with_permissions(@user, :destroy?)
      @user.destroy!
      render jsonapi: auth_user.record,
             serializer: UserSerializer,
             user: { user: auth_user.fields }      
    end
    
    private
    
    def load_resource
      case params[:action].to_sym
      when :index
        @users = paginate(search(User)) 
      when :create
        @user = User.new create_params
      when :show, :update, :destroy
        @user = User.find params[:id]
      end
    end    
      
    def create_params
      normalized_params.permit(
        :username, :email, :password, :name, :nickname, :image
      ) 
    end

    def update_params
      create_params
    end

    def normalized_params
      ActionController::Parameters.new(
         ActiveModelSerializers::Deserialization.jsonapi_parse(params)
      )
    end
    
    def update_roles!
    	roles = normalized_params.permit![:roles]
    	roles.each do |role| @user.add_role role end    	
    	(@user.roles.map(&:name) - roles).each do |role| @user.remove_role role end
    	true
    end     
    
  end
end