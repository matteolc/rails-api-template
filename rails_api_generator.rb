def migration_ts
	sleep(1)
	Proc.new { Time.now.strftime("%Y%m%d%H%M%S") }
end    
	
def copy_from_repo(filename, opts={})
  repo = "https://raw.githubusercontent.com/matteolc/rails-api-template/master/"
  source_filename = filename
  destination_filename = filename  
  destination_filename  = destination_filename.gsub(/create/, "#{migration_ts.call}_create") if opts[:migration_ts]
  begin
    remove_file destination_filename
    get repo + source_filename, destination_filename
  rescue OpenURI::HTTPError
    puts "Unable to obtain #{source_filename} from the repo #{repo}"
  end
end

def commit(msg)
  git add: "."
  git commit: "-m '#{msg}'"	
end

git :init
commit "Initial commit"

# Gems
gem 'annotate', group: :development
gem_group :development, :test do
  gem 'awesome_print'
  gem 'faker'
  gem 'factory_girl_rails'
  gem 'rspec-rails'
end
gem 'dotenv-rails'
gem 'default_value_for'
gem 'chronic'
gem 'sidekiq'
gem 'rufus-scheduler'
gem 'daemons'
gem 'rollbar'
gem 'jsonapi-resources'
gem 'pg_search'
gem 'dotenv-rails'
gem 'puma_worker_killer'
gem 'pundit'
gem 'jsonapi-authorization', git: 'https://github.com/venuu/jsonapi-authorization.git'
gem 'rolify'
gem 'jwt'
gsub_file 'Gemfile', "# gem 'rack-cors'", "gem 'rack-cors'"
gsub_file 'Gemfile', "# gem 'bcrypt', '~> 3.1.7'", "gem 'bcrypt', '~> 3.1.7'"
run 'bundle install'

%w(user role json_web_token).each do |model|  # Models
  copy_from_repo "app/models/#{model}.rb"
end
empty_directory 'app/models/concerns' 
copy_from_repo 'app/models/concerns/has_secure_tokens.rb' # JWT
empty_directory 'lib/templates/active_record/model' # Models template
copy_from_repo "lib/templates/active_record/model/model.rb"
empty_directory 'app/resources/api/v1' 
%w(api user).each do |resource|  # JSONAPI resources
  copy_from_repo "app/resources/api/v1/#{resource}_resource.rb"
end
create_file "app/resources/api/v1/account_resource.rb" do
  "class Api::V1::AccountResource < Api::V1::ApiResource
    attributes  :email,
                :username
  end"
end
empty_directory 'app/controllers/api/v1' # Controllers
%w(api registrations sessions).each do |controller|
  copy_from_repo "app/controllers/api/v1/#{controller}_controller.rb"
end
create_file "app/controllers/api/v1/accounts_controller.rb" do
  "class Api::V1::AccountsController < Api::V1::ApiController
  end"
end
create_file "app/controllers/api/v1/users_controller.rb" do
  "class Api::V1::UsersController < Api::V1::ApiController
  end"
end
create_file "app/controllers/api/v1/user_processor.rb" do
  "class Api::V1::UserProcessor < JSONAPI::Authorization::AuthorizingProcessor
    after_find do
      unless @result.is_a?(JSONAPI::ErrorsOperationResult)
        @result.meta[:record_total] = User.count
      end
    end
  end"
end
insert_into_file "app/controllers/application_controller.rb", after: "class ApplicationController < ActionController::API" do # Authorization
  "
  include Authorization"
end
empty_directory 'app/controllers/concerns' 
copy_from_repo 'app/controllers/concerns/authorization.rb' # Authorization
empty_directory 'app/policies' # Policies
%w(application user account).each do |policy|
  copy_from_repo "app/policies/#{policy}_policy.rb"
end
%w(extensions users roles).each do |migration| # Migrations
  copy_from_repo "db/migrate/create_#{migration}.rb", {migration_ts: true}
end 
%w(redis rollbar cors generators jsonapi_resources).each do |initializer| # Initializers
  copy_from_repo "config/initializers/#{initializer}.rb"
end
copy_from_repo "config/sidekiq.yml"
copy_from_repo "config/puma.rb"
prepend_to_file 'config/database.yml' do # Db config
  "local: &local
    username: <%= ENV['DATABASE_USER'] %>
    password: <%= ENV['DATABASE_PASSWORD'] %>
    host: <%= ENV['DATABASE_HOST'] %>
  "
end
insert_into_file "config/database.yml", after: "<<: *default\n" do 
"  <<: *local\n" 
end
# Db seeds
empty_directory 'db/seeds'
copy_from_repo "db/seeds/users.rb"
application "config.active_record.default_timezone = :utc" # Timezone
application "config.active_job.queue_adapter = :sidekiq" # Job processor        
# Rake tasks
rakefile("auto_annotate_models.rake") do <<-'TASK'    
if Rails.env.development?
  task :set_annotation_options do
    Annotate.set_defaults({
      'routes'                    => 'false',
      'position_in_routes'        => 'before',
      'position_in_class'         => 'before',
      'position_in_test'          => 'before',
      'position_in_fixture'       => 'before',
      'position_in_factory'       => 'before',
      'position_in_serializer'    => 'before',
      'show_foreign_keys'         => 'true',
      'show_complete_foreign_keys' => 'false',
      'show_indexes'              => 'true',
      'simple_indexes'            => 'false',
      'model_dir'                 => 'app/models',
      'root_dir'                  => '',
      'include_version'           => 'false',
      'require'                   => '',
      'exclude_tests'             => 'true',
      'exclude_fixtures'          => 'true',
      'exclude_factories'         => 'true',
      'exclude_serializers'       => 'false',
      'exclude_scaffolds'         => 'true',
      'exclude_controllers'       => 'true',
      'exclude_helpers'           => 'true',
      'exclude_sti_subclasses'    => 'false',
      'ignore_model_sub_dir'      => 'false',
      'ignore_columns'            => nil,
      'ignore_routes'             => nil,
      'ignore_unknown_models'     => 'false',
      'hide_limit_column_types'   => '<%= AnnotateModels::NO_LIMIT_COL_TYPES.join(",") %>',
      'hide_default_column_types' => '<%= AnnotateModels::NO_DEFAULT_COL_TYPES.join(",") %>',
      'skip_on_db_migrate'        => 'false',
      'format_bare'               => 'true',
      'format_rdoc'               => 'false',
      'format_markdown'           => 'true',
      'sort'                      => 'false',
      'force'                     => 'false',
      'trace'                     => 'false',
      'wrapper_open'              => nil,
      'wrapper_close'             => nil,
      'with_comment'              => true
    })
  end

  Annotate.load_tasks
  
  # Annotate models
  task :annotate do
    puts 'Annotating models...'    
    system 'bundle exec annotate'
  end
  
  # Annotate routes
  task :annotate_routes do
    puts 'Annotating models...'
    system 'bundle exec annotate --routes'
  end

end    
TASK
end

rakefile("app.rake") do <<-'TASK'    
  namespace :app do
    task :bootstrap => :environment do
      Rake::Task['db:drop'].invoke
      Rake::Task['db:create'].invoke
      Rake::Task['db:migrate'].invoke
    end
 end    
TASK
end

rakefile("custom_seed.rake") do <<-'TASK'  
namespace :db do
  namespace :seed do
    Dir[Rails.root.join('db', 'seeds', '*.rb')].each do |filename|
      task_name = File.basename(filename, '.rb').intern    
      task task_name => :environment do
        load(filename) if File.exist?(filename)
      end     
    end
  end
end
TASK
end

insert_into_file "config/routes.rb", after: "Rails.application.routes.draw do" do # Routes
  "
   namespace :api do
    namespace :v1 do
      post 'login', to: 'sessions#create'
      delete 'logout', to: 'sessions#destroy'
      post 'signup', to: 'registrations#create'
      jsonapi_resources :accounts, only: [:show, :edit, :update]
      jsonapi_resources :users
    end
  end"
end



create_file "Procfile", "web: bundle exec puma -C config/puma.rb" # Procfile

commit "Creation"

run 'bundle exec rake app:bootstrap'


