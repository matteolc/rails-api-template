# frozen_string_literal: true

app_path = ENV.fetch('APP_PATH') { './' }

# Specifies the `environment` that Puma will run in.
environment ENV.fetch('RAILS_ENV') { 'development' }

# Store the pid of the server in the file at "path".
pidfile File.join(app_path, 'tmp/puma.pid')

# Use "path" as the file to store the server info state. This is
# used by "pumactl" to query and control the server.
#
state_path File.join(app_path, 'tmp/puma.state')

# Redirect STDOUT and STDERR to files specified. The 3rd parameter
# ("append") specifies whether the output is appended, the default is
# "false".
stdout_redirect File.join(app_path, 'log/puma'), File.join(app_path, 'log/puma_err'), true

# Puma can serve each request in a thread from an internal thread pool.
# The `threads` method setting takes two numbers: a minimum and maximum.
# Any libraries that use thread pools should be configured to match
# the maximum value specified for Puma. Default is set to 5 threads for minimum
# and maximum; this matches the default thread size of Active Record.
threads_count = ENV.fetch('RAILS_MAX_THREADS') { 5 }
threads threads_count, threads_count

# Specifies the `port` that Puma will listen on to receive requests; default is 3000.
# port        ENV.fetch('PORT') { 5000 }

# Bind the server to "url". "tcp://", "unix://" and "ssl://" are the only
# accepted protocols.
bind "tcp://0.0.0.0:#{ENV.fetch('PORT') { 5000 }}?backlog=2048"
bind 'unix:///var/run/puma.sock?backlog=2048'

# Specifies the number of `workers` to boot in clustered mode.
# Workers are forked webserver processes. If using threads and workers together
# the concurrency of the application would be max `threads` * `workers`.
# Workers do not work on JRuby or Windows (both of which do not support
# processes).
workers ENV.fetch('WEB_CONCURRENCY') { 3 }

# Use the `preload_app!` method when specifying a `workers` number.
# This directive tells Puma to first boot the application and load code
# before forking the application. This takes advantage of Copy On Write
# process behavior so workers use less memory. If you use this option
# you need to make sure to reconnect any threads in the `on_worker_boot`
# block.
preload_app!

# If you are preloading your application and using Active Record, it's
# recommended that you close any connections to the database before workers
# are forked to prevent connection leakage.
before_fork do
  puts 'Puma master process about to fork. Closing existing Active record connections.'
  ActiveRecord::Base.connection_pool.disconnect! if defined?(ActiveRecord)
  Rails.env.production? && PumaWorkerKiller.config do |config|
    config.ram = ENV.fetch('HOST_RAM_MB').to_f { 1024 } # mb
    config.frequency     = 20 # seconds
    config.percent_usage = 0.98
    config.rolling_restart_frequency = 12 * 3600 # 12 hours in seconds
  end
  PumaWorkerKiller.start
end

# The code in the `on_worker_boot` will be called if you are using
# clustered mode by specifying a number of `workers`. After each worker
# process is booted, this block will be run. If you are using the `preload_app!`
# option, you will want to use this block to reconnect to any threads
# or connections that may have been created at application boot, as Ruby
# cannot share connections between processes.
on_worker_boot do |worker_number|
  Rails.logger.info "Initializing Puma Worker #{worker_number}.."
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
end

# Code to run in a worker right before it exits.
on_worker_shutdown do |worker_number|
  puts "Shutting down Puma Worker #{worker_number}.."
end

# Code to run in the master right before a worker is started. The worker's
# index is passed as an argument.
on_worker_fork do |worker_number|
  puts "Before worker #{worker_number} fork..."
end

# Code to run in the master after a worker has been started. The worker's
# index is passed as an argument.
after_worker_fork do |worker_number|
  puts "After worker #{worker_number} fork..."
end

# Allow puma to be restarted by `rails restart` command.
plugin :tmp_restart

# === Puma control rack application ===

# Start the puma control rack application on "url". This application can
# be communicated with to control the main server. Additionally, you can
# provide an authentication token, so all requests to the control server
# will need to include that token as a query parameter. This allows for
# simple authentication.
#
# Check out https://github.com/puma/puma/blob/master/lib/puma/app/status.rb
# to see what the app has available.
#
activate_control_app 'unix:///var/run/pumactl.sock'