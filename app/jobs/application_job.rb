# frozen_string_literal: true

class ApplicationJob < ActiveJob::Base
    discard_on(StandardError) do |job, exception|
        puts(exception)
    end
end