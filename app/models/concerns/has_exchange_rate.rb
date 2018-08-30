# frozen_string_literal: true

module HasExchangeRate
  extend ActiveSupport::Concern

  class_methods do
    def has_exchange_rate(options = {}); end
  end

  included do  

    default_value_for :currency_code, ENV['CURRENCY']

  end

  def effective_exchange_rate
      ENV['CURRENCY'] === currency_code ? 1 : OpenExchangeRate.get_exchange_rate(currency_code, ENV['CURRENCY'])
  end

end
