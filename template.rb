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

def ask_default(question, default_answer)
  answer = ask(question) 
  answer.empty? ? default_answer : answer
end

def commit(msg)
  git add: "."
  git commit: "-m '#{msg}'"	
end

git :init
commit "Initial commit"

# Gemfile
gem 'annotate', group: :development
gem 'rubocop', require: false, group: :development
gem_group :development, :test do
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  gem 'rspec-rails'
  gem 'pry-rails'
end
gem 'jsonapi-resources'
gem 'jsonapi-authorization', git: 'https://github.com/venuu/jsonapi-authorization.git'
gem 'dalli'
gem 'connection_pool'
gem 'dotenv-rails'
gem 'default_value_for'
gem 'jwt'
gem 'pg_search'
gem 'jsonb_accessor', '~> 1.0.0'
gem 'puma_worker_killer'
gem 'pundit'
gem 'rolify'
gem 'faker'
gsub_file 'Gemfile', "# gem 'rack-cors'", "gem 'rack-cors'"
gsub_file 'Gemfile', "# gem 'bcrypt', '~> 3.1.7'", "gem 'bcrypt', '~> 3.1.7'"
run 'bundle install'

# app
remove_file 'app/channels'
remove_file 'app/mailers'
remove_file 'app/jobs'
remove_file 'app/views'

# app/models
%w(account user role json_web_token).each do |model| copy_from_repo "app/models/#{model}.rb" end

# app/models/concerns
%w(has_secure_tokens has_fulltext_search).each do |concern| copy_from_repo "app/models/concerns/#{concern}.rb" end

# app/controllers
empty_directory 'app/controllers/api/v1'
copy_from_repo 'app/controllers/application_controller.rb'
%w(api registrations sessions users accounts).each do |controller| copy_from_repo "app/controllers/api/v1/#{controller}_controller.rb" end

# app/controllers/concerns
copy_from_repo 'app/controllers/concerns/authorization.rb' 

# app/policies
empty_directory 'app/policies' 
%w(application user account).each do |policy| copy_from_repo "app/policies/#{policy}_policy.rb" end

# app/resources
empty_directory 'app/resources/api/v1' 
%w(api user account).each do |resource| copy_from_repo "app/resources/api/v1/#{resource}_resource.rb" end

# spec
empty_directory 'spec/factories'
empty_directory 'spec/models'
empty_directory 'spec/support'
copy_from_repo 'spec/rails_helper.rb'
copy_from_repo 'spec/spec_helper.rb'
copy_from_repo 'spec/support/factory_bot.rb'
copy_from_repo 'spec/factories/users.rb'
copy_from_repo 'spec/models/user_spec.rb'
  
# config
application "config.active_record.default_timezone = :utc" 
application "config.active_record.schema_format = :sql"
gsub_file 'config/application.rb', 'require "active_job/railtie"', '# require "active_job/railtie"'
gsub_file 'config/application.rb', 'require "active_storage/engine"', '# require "active_storage/engine"'
gsub_file 'config/application.rb', 'require "action_mailer/railtie"', '# require "action_mailer/railtie"'
gsub_file 'config/application.rb', 'require "action_view/railtie"', '# require "action_view/railtie"'
gsub_file 'config/application.rb', 'require "action_cable/engine"', '# require "action_cable/engine"'
copy_from_repo "config/puma.rb"

# config/environments/development.rb
gsub_file 'config/environments/development.rb', ':memory_store', ":dalli_store, 'localhost:11211', { :pool_size => ENV.fetch('WEB_CONCURRENCY') || 3  }"
gsub_file 'config/environments/development.rb', 'config.active_storage.service = :local', '# config.active_storage.service = :local'
gsub_file 'config/environments/development.rb', 'config.action_mailer.raise_delivery_errors = false', '# config.action_mailer.raise_delivery_errors = false'
gsub_file 'config/environments/development.rb', 'config.action_mailer.perform_caching = false', '# config.action_mailer.perform_caching = false'

# config/environments/test.rb 
gsub_file 'config/environments/test.rb', 'config.active_storage.service = :test', '# config.active_storage.service = :test'
gsub_file 'config/environments/test.rb', 'config.action_mailer.perform_caching = false', '# config.action_mailer.perform_caching = false'
gsub_file 'config/environments/test.rb', 'config.action_mailer.delivery_method = :test', '# config.action_mailer.delivery_method = :test'

# config/environments/production.rb
gsub_file 'config/environments/production.rb', '# config.cache_store = :mem_cache_store', "config.cache_store = :dalli_store, 'localhost:11211', { :pool_size => ENV.fetch('WEB_CONCURRENCY') || 3  }"
gsub_file 'config/environments/production.rb', 'config.active_storage.service = :local', '# config.active_storage.service = :local'
gsub_file 'config/environments/production.rb', 'config.action_mailer.perform_caching = false', '# config.action_mailer.perform_caching = false'

# config/database.yml
prepend_to_file 'config/database.yml' do 
  "local: &local
    username: <%= ENV['DATABASE_USER'] %>
    password: <%= ENV['DATABASE_PASSWORD'] %>
    host: <%= ENV['DATABASE_HOST'] %>
  "
end
insert_into_file "config/database.yml", after: "<<: *default\n" do 
"  <<: *local\n" 
end

# config/initializers
%w(cors generators jsonapi_resources).each do |initializer| copy_from_repo "config/initializers/#{initializer}.rb" end

# config/routes.rb
insert_into_file "config/routes.rb", after: "Rails.application.routes.draw do" do "
  namespace :api do
   namespace :v1 do
     post 'login', to: 'sessions#create'
     delete 'logout', to: 'sessions#destroy'
     post 'signup', to: 'registrations#create'
     jsonapi_resources :accounts, only: [:show, :edit, :update]
     jsonapi_resources :users
   end
 end
 get '/', to: 'application#not_found'
 get '*path', to: 'application#not_found'
 post '*path', to: 'application#not_found'"
end

# db/migrate
%w(extensions users roles).each do |migration| copy_from_repo "db/migrate/create_#{migration}.rb", {migration_ts: true} end 

# db/seeds
empty_directory 'db/seeds'
copy_from_repo "db/seeds/users.rb"

# lib/tasks
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
    task :setup => :environment do
      Rake::Task['db:create'].invoke
      Rake::Task['db:migrate'].invoke
      Rake::Task['db:seed:users'].invoke
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

# Procfile
create_file "Procfile", "web: bundle exec puma -C config/puma.rb" 

db_user = ask_default("Who is the database user (leave empty for dba)?", 'dba') 
db_password = ask_default("What is the database password (leave empty for 12345678)?", '12345678')
db_host = ask_default("Who is the database host (leave empty for localhost)?", 'localhost')
jwt_secret = ask_default("Please choose a JWT secret (leave empty for secret)", 'secret')

create_file '.env' do
  "DATABASE_USER=#{db_user}
  DATABASE_PASSWORD=#{db_password}
  DATABASE_HOST=#{db_host}
  JWT_SECRET=#{jwt_secret}"
end

append_to_file '.gitignore', '.env'
append_to_file '.gitignore', '/vendor/bundle/*'

commit "Creation"

run 'bundle exec rake app:setup'

commit "Setup"

if (excel_support = yes?("Do you want to add support for Excel?"))

  gem 'axlsx', '~> 2.1.0.pre'  
  gem 'roo'
  gem 'roo-xls'
  gem 'spreadsheet_architect', '~> 2.0.2'

  empty_directory 'app/models/concerns/acts_as_spreadsheet'
  copy_from_repo "app/models/concerns/acts_as_spreadsheet/spreadsheet.rb"
  copy_from_repo "app/controllers/api/v1/excel_controller.rb"

  insert_into_file "config/routes.rb", after: "jsonapi_resources :users" do "
    get 'download', to: 'excel#download'"
  end    

  run 'bundle install'

  commit "Excel"

end

if (pdf_support = yes?("Do you want to add support for PDF?"))

  gem 'wicked_pdf'
  gem 'wkhtmltopdf-binary'

  copy_from_repo "app/controllers/api/v1/pdf_controller.rb"

  insert_into_file "config/routes.rb", after: "jsonapi_resources :users" do "
    get 'print/:id', to: 'pdf#print'"
  end  

  gsub_file 'config/application.rb', '# require "action_view/railtie"', 'require "action_view/railtie"' 
  empty_directory 'app/views/layouts'
  copy_from_repo "app/views/layouts/pdf.html.erb"  

  run 'bundle install'

  commit "PDF"

end

if (bj_support = yes?("Do you want to add support for background jobs and scheduling?"))

  gem 'rufus-scheduler'
  gem 'sidekiq'

  copy_from_repo "config/sidekiq.yml"
  copy_from_repo "config/initializers/redis.rb"
  copy_from_repo "config/initializers/sidekiq.rb"

  gsub_file 'config/application.rb', '# require "active_job/railtie"', 'require "active_job/railtie"' 
  application "config.active_job.queue_adapter = :sidekiq"
  empty_directory 'app/jobs'
  copy_from_repo "app/jobs/application_job.rb"

  append_to_file '.env' do "
REDIS_URL=redis://127.0.0.1:6379"
  end

  run 'bundle install'

  commit "jobs & scheduler"

end

if (email_support = yes?("Do you want to add support for email?"))  

  # TODO: add css gem

  gsub_file 'config/application.rb', '# require "action_mailer/railtie"', 'require "action_mailer/railtie"' 
  empty_directory 'app/mailers'
  copy_from_repo 'app/mailers/application_mailer.rb' 
  gsub_file 'config/environments/development.rb', '# config.action_mailer.raise_delivery_errors = false', 'config.action_mailer.raise_delivery_errors = false'
  gsub_file 'config/environments/development.rb', '# config.action_mailer.perform_caching = false', 'config.action_mailer.perform_caching = false'
  gsub_file 'config/environments/production.rb', '# config.action_mailer.perform_caching = false', 'config.action_mailer.perform_caching = false'
  # TODO: add production smarthost settings

  email_dn = ask_default("What is your email domain name (leave empty for example.com)?", 'example.com') 
  append_to_file '.env' do "
MAILER_DOMAIN=#{email_dn}"
  end

  copy_from_repo "app/views/layouts/mailer.text.erb"
  # TODO: update template for css
  copy_from_repo "app/views/layouts/mailer.html.erb"

  run 'bundle install'

  commit "email"

end

if (net_support = yes?("Do you want to add basic networking tools?"))

  gem 'net-ssh'
  gem 'net-sftp'
  gem 'net-telnet'

  run 'bundle install'

  commit "basic networking tools"

end  

if (reporting_support = yes?("Do you want to add basic reporting tools?"))

  gem 'kaminari'
  gem 'descriptive_statistics'
  gem 'by_star'

  run 'bundle install'

  commit "basic reporting tools"

end

if (reporting_support = yes?("Do you need full ISO countries support and money, exchange rates information?"))

  gem 'countries'
  gem 'money'
  gem 'money-open-exchange-rates'
  gem 'money-rails', '~>1'
  gem 'normalize_country'

  copy_from_repo 'config/initializers/countries.rb'
  copy_from_repo 'config/initializers/money.rb'
  copy_from_repo 'app/models/concerns/has_exchange_rate.rb'
  copy_from_repo 'app/models/open_exchange_rate.rb'
  copy_from_repo 'app/models/country.rb'
  copy_from_repo "db/migrate/create_countries.rb", {migration_ts: true} 
  copy_from_repo "db/seeds/countries.rb"  
  copy_from_repo "spec/factories/countries.rb"
  copy_from_repo "spec/models/country_spec.rb"

  currency = ask_default("What is your default currency code (leave empty for EUR)?", 'EUR')
  oer_secret = ask_default("What is your Open Exchange Rates secret?", '')
  append_to_file '.env' do "
CURRENCY=#{currency}
OPEN_EXCHANGE_RATE_SECRET=#{oer_secret}"
  end

  run 'bundle install'
  run 'bundle exec rake db:migrate'
  run 'bundle exec rake db:seed:countries'

  commit "countries, money and exchange rates support"

end

if (debug_support = yes?("Do you want application debug support (Rollbar & Newrelic)?"))
  gem 'rollbar'
  gem 'newrelic_rpm'

  copy_from_repo 'config/initializers/rollbar.rb'
  copy_from_repo 'config/newrelic.yml'

  nr_app = ask_default("What is your New Relic application name (leave empty for app)?", 'app')
  nr_key = ask_default("What is your New Relic key?", '')
  rollbar_token = ask_default("What is your Rollbar token?", '')
  append_to_file '.env' do "
NEW_RELIC_KEY=#{nr_key}
NEW_RELIC_APP_NAME=#{nr_app}  
ROLLBAR_TOKEN=#{rollbar_token}"
  end

  run 'bundle install'

  commit "application debug support"

end




