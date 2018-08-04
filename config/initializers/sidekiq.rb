Sidekiq.configure_server do |config|
    config.on(:quiet) do
      puts "Got TSTP, stopping further job processing..."    
    end
    config.on(:shutdown) do
      puts "Got TERM, shutting down process..."
    end  
end