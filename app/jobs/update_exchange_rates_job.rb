class UpdateExchangeRatesJob < ApplicationJob
    queue_as :critical
   
    def perform() OpenExchangeRate.new.update_rates end
          
end