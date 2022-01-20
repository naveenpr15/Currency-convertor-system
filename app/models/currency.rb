class Currency < ApplicationRecord
	validates :name, :code, presence: true
	validates :name, :code, uniqueness: true
	validates :code, length: { minimum:3, maximum: 4 }

	has_one :rate

	def self.convert(from_currency, to_currency, value)
    amount = value.to_f
    from_currency = Currency.find_by(code: from_currency)
    to_currency = Currency.find_by(code: to_currency)
    if (from_currency.present? && to_currency.present? && amount >= 0)
      from_currency_rate = from_currency.rate.rate
    	to_currency_rate = to_currency.rate.rate
    	result = (amount / from_currency_rate) * to_currency_rate
    else
      return nil
    end
  end
end
