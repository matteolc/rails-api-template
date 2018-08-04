# frozen_string_literal: true

require 'money/bank/open_exchange_rates_bank'

class OpenExchangeRate
  def initialize
    @moe = Money::Bank::OpenExchangeRatesBank.new
    @moe.cache = 'tmp/rates'
    @moe.app_id = ENV['OPEN_EXCHANGE_RATE_SECRET']
  end

  def update_rates
    @moe.update_rates
    @moe.save_rates
    Money.default_bank = @moe
  end

  def self.update_rates
    new.update_rates if Money.default_bank.rates.empty?
  end

  def self.exists_exchange_rate_for_currency?(currency_code)
    result = get_exchange_rate_usd(currency_code)
    return false if result.nil? || result == 'Unknown Currency'
    true
  end

  def self.get_exchange_rate_usd(to_currency_code)
    return 'Unknown Currency' unless Money::Currency.table.map { |t| t[1][:iso_code] }.include?(to_currency_code)
    update_rates
    Money.default_bank.get_rate 'USD',
                                to_currency_code
  end

  def self.get_exchange_rate(from_currency_code, to_currency_code)
    exchange_rate_usd = get_exchange_rate_usd(to_currency_code)
    return exchange_rate_usd if from_currency_code === 'USD'
    exchange_rate_from = get_exchange_rate_usd(from_currency_code)
    return nil unless exchange_rate_from || exchange_rate_from == 'Unknown Currency'
    exchange_rate_usd / exchange_rate_from
  end

end
