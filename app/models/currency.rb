class Currency < ApplicationRecord
	validates :name, :code, presence: true
	validates :name, :code, uniqueness: true
	validates :code, length: { minimum:3, maximum: 4 }

	has_one :rate

  def self.make_rate_api_call(currency)
    response = HTTParty.get("#{ENV["RATES_DOMAIN"]}?key=#{ENV["API_KEY"]}")
    new_curr_rate = response['rates'][currency.code]
    r = currency.rate
    r.rate = new_curr_rate
    r.save
  end

  def self.check_rate_updated_at(from_currency, to_currency)
    from_curr_rate_updated_at = from_currency.rate.updated_at
    to_curr_rate_updated_at = to_currency.rate.updated_at
    f_curr_rate_time_diff = (Time.current - from_curr_rate_updated_at) / 60
    t_curr_rate_time_diff = (Time.current - to_curr_rate_updated_at) / 60

    if f_curr_rate_time_diff > 30
      Currency.make_rate_api_call(from_currency)
    end
    if t_curr_rate_time_diff > 30
      Currency.make_rate_api_call(to_currency)
    end
  end


	def self.convert(from_currency, to_currency, value)
    amount = value.to_f
    from_currency = Currency.find_by(code: from_currency)
    to_currency = Currency.find_by(code: to_currency)
    Currency.check_rate_updated_at(from_currency, to_currency)
    if (from_currency.present? && to_currency.present? && amount >= 0)
      from_currency_rate = from_currency.rate.rate
    	to_currency_rate = to_currency.rate.rate
    	result = (amount / from_currency_rate) * to_currency_rate
    else
      return nil
    end
  end
end
