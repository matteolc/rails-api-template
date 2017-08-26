def migration_ts
	sleep(1)
	Proc.new { Time.now.strftime("%Y%m%d%H%M%S") }
end    
	
def copy_from_repo(filename, opts={})
  repo = "https://raw.githubusercontent.com/matteolc/rails_api_template/master/"
  source_filename = filename
  destination_filename = filename  
  destination_filename  = destination_filename.gsub(/create/, "#{migration_ts.call}_create") if opts[:migration_ts]
  begin
    remove_file destination_filename
    get repo + source_filename, destination_filename
  rescue OpenURI::HTTPError
    say_wizard "Unable to obtain #{source_filename} from the repo #{repo}"
  end
end

def commit(msg)
  git add: "."
  git commit: "-m '#{msg}'"	
end

##########################
### GEMSET
##########################
create_file '.ruby-version' do "2.3.3" end  
gemset_name = ask("What is the name of the gemset?")
gemset_name = "a-ruby-application" if gemset_name.blank?
application_name = gemset_name
create_file '.ruby-gemset' do "#{gemset_name}" end

git :init
commit "Initial commit"

##########################
### GEMS
##########################

gem 'dotenv-rails'
gem 'annotate', group: :development
gem 'awesome_print', group: [:development, :test]
gem 'faker'
gem 'factory_girl_rails', group: [:development, :test]
gem 'rspec-rails', group: [:development, :test] 
gem 'rack-cors', :require => 'rack/cors'
gem 'default_value_for'
gem 'humanize'
gem 'descriptive_statistics'
gem 'time_difference'
gem 'week_of_month'
gem 'chronic'
gem 'by_star', git: 'git://github.com/radar/by_star'
gem 'groupdate'
gem 'rubyzip'
gem 'devise_token_auth'
gem 'pundit'
gem 'rolify'
gem 'flexible_permissions'
gem 'active_model_serializers', '~> 0.10.0'
gem 'kaminari'
gem 'sidekiq'
gem 'rufus-scheduler'
gem 'daemons'
gem 'money'
gem 'money-rails', '~>1'
gem 'calculate-all'
gem 'active_hash_relation', '~> 1.4.0'
gem 'pg_search'
gem 'http_accept_language'
gem 'rubyzip'
gem 'countries'
gem 'rails-i18n', '~> 5.0.0'
gem 'puma_worker_killer'

append_to_file "Gemfile", "\nruby '2.3.3'"
run 'bundle install'

##########################
### MODELS
##########################
%w(user role).each do |model|  
  copy_from_repo "app/models/#{model}.rb"
end

##########################
### CONTROLLERS
##########################
empty_directory 'app/controllers/api/v1'
%w(api users).each do |controller|
  copy_from_repo "app/controllers/api/v1/#{controller}_controller.rb"
end

##########################
### POLICIES
##########################
empty_directory 'app/policies'
%w(application user).each do |policy|
  copy_from_repo "app/policies/#{policy}_policy.rb"
end

##########################
### SERIALIZERS
##########################
empty_directory 'app/serializers/api/v1'
%w(api error user).each do |serializer|
  copy_from_repo "app/serializers/api/v1/#{serializer}_serializer.rb"
end  

##########################
### DATABASE
##########################
db_user = ask("What is the database user?")
db_secret = ask("What is the database password?")
db_secret = "" if db_secret.blank?    
prepend_to_file 'config/database.yml' do
"local: &local
  username: #{db_user}
  password: #{db_secret}
  host: localhost\n"
end
insert_into_file "config/database.yml", after: "<<: *default\n" do 
"  <<: *local\n" 
end
run "bin/rails db:environment:set RAILS_ENV=development"
run "bundle exec rake db:drop"
run "bundle exec rake db:create"

##########################
### MIGRATIONS
##########################   
%w(pg_extensions users roles).each do |migration|
  copy_from_repo "db/migrate/create_#{migration}.rb", {migration_ts: true}
end 

run "bundle exec rake db:migrate"

##########################
### CONFIGURATION
##########################

comment_lines 'config/application.rb', /require "action_view\/railtie"/

### CORS
application "
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*', 
                 headers: :any, 
                 methods: [:get, :post, :options, :delete, :put, :patch, :head],                
                 expose: ['access-token', 'expiry', 'token-type', 'uid', 'client']
      end
    end
"

### APPLICATION
application "config.active_record.default_timezone = :utc"
application "config.i18n.default_locale = :en"
application "config.i18n.available_locales = %w(en)"
application "config.active_job.queue_adapter = :sidekiq"

### INITIALIZERS
%w(active_hash_relation active_model_serializers money redis rollbar devise devise_token_auth kaminari).each do |initializer|
  copy_from_repo "config/initializers/#{initializer}.rb"
end
copy_from_repo "config/sidekiq.yml"
copy_from_repo "config/puma.rb"

### PRODUCTION MAILER
application(nil, env: "production") do
  "config.action_mailer.default_url_options = { host: ENV['FQDN'] }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default :charset => 'utf-8'  

  config.action_mailer.smtp_settings = {
    address: 'smtp.sendgrid.net',
    port: 587,
    enable_starttls_auto: true,
    user_name: ENV['SENDGRID_ACCOUNT'],
    password: ENV['SENDGRID_KEY'],
    domain: ENV['FQDN'],
    authentication: 'plain'
  } "
end
          
##########################
### ROUTES
##########################

insert_into_file "config/routes.rb", after: "Rails.application.routes.draw do" do "

  namespace :api do     
    mount_devise_token_auth_for 'User', at: 'auth', skip: [:omniauth_callbacks]

    namespace :v1 do      
  		resources :users, only: [:index, :show, :update, :create, :destroy]
  	end
  end"
end

##########################
### TASKS
##########################
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
    task :reset => :environment do
      Rake::Task['db:drop'].invoke
      Rake::Task['db:create'].invoke
      Rake::Task['db:migrate'].invoke
    end
    task :seed => :environment do      
      Rake::Task['db:seed'].invoke
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

##########################
### SEED
##########################
empty_directory 'db/seeds'
copy_from_repo "db/seeds/users.rb"

run "bundle exec rake db:seed:users"

##########################
### PATCHES
##########################
comment_lines 'app/controllers/application_controller.rb', /protect_from_forgery with: :exception/

##########################
### PROCFILE
##########################
create_file "Procfile", "web: bundle exec puma -C config/puma.rb"

commit "Creation"


