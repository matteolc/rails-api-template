# frozen_string_literal: true

if Rails.env.production?
    Sidekiq.configure_client do |config|
      config.redis = { url: ENV['REDIS_URL'], size: 1 }
    end
end
  