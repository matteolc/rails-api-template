RAILS_ROOT = ENV["RAILS_ROOT"] || Dir.pwd

worker_processes Integer(ENV["UNICORN_WORKERS"] || 16)
timeout 10000
preload_app true     
GC.respond_to?(:copy_on_write_friendly=) and GC.copy_on_write_friendly = true

pid "#{RAILS_ROOT}/tmp/pids/unicorn.pid"
working_directory RAILS_ROOT

if Rails.env.development? 
  listen "3000"
else
  listen "#{RAILS_ROOT}/tmp/sockets/unicorn.sock", :backlog => 2048
end

stderr_path "#{RAILS_ROOT}/log/unicorn.stderr.log"
stdout_path "#{RAILS_ROOT}/log/unicorn.stdout.log"  

require "#{RAILS_ROOT}/config/initializers/scheduler"
scheduler_pid_file = "#{RAILS_ROOT}/tmp/pids/scheduler.pid"

before_fork do |server, worker|
	
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect! 

  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end	
  
  old_pid = "#{RAILS_ROOT}/tmp/pids/unicorn.pid.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end  

end

after_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT'
  end	
    
  if defined?(ActiveRecord::Base)
    config = ActiveRecord::Base.configurations[Rails.env] || Rails.application.config.database_configuration[Rails.env]
    config['reaping_frequency'] =  ENV['DB_REAP_FREQ'] || 10
    config['pool'] =  ENV['DB_POOL'] || 50
    ActiveRecord::Base.establish_connection(config)
    child_pid = server.config[:pid].sub('.pid', ".#{worker.nr}.pid")
    system("echo #{Process.pid} > #{child_pid}")
    Scheduler::start_unless_running scheduler_pid_file    
  end
  
end
