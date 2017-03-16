require 'rufus-scheduler'
class Scheduler

  def self.start_unless_running(pid_file)
    with_lockfile(File.join(File.dirname(pid_file), 'scheduler.lock')) do
      if File.exists?(pid_file)
        pid = IO.read(pid_file).to_i
        if pid > 0 && process_running?(pid)
          puts "not starting scheduler because it already is running with pid #{pid}"
        else
          puts "Process #{$$} removes stale pid file"
          File.delete pid_file
        end
      end

      if !File.exists?(pid_file)
        (File.new(pid_file,'w') << $$).close
        puts "scheduler process is: #{$$}"
        new.setup_jobs
      end
      true
    end or puts "could not start scheduler - lock not acquired"
  end

  def self.process_running?(pid)
    Process.kill(0, pid)
    true
  rescue Exception
    false
  end 

  def self.with_lockfile(lock_file)
    lock = File.new(lock_file, 'w')
    begin
      if lock.flock(File::LOCK_EX | File::LOCK_NB)
        yield
      else
        return false
      end 
    ensure
      lock.flock(File::LOCK_UN)
      File.delete lock
    end 
  end

  def initialize
    @rufus_scheduler = Rufus::Scheduler.new
    @rufus_scheduler.class_eval do define_method :handle_exception do |job, exception| puts "job #{job.job_id} caught exception '#{exception}'" end end
  end

  def setup_jobs
    
    p 'Scheduler initialized.'
    
  end

end

