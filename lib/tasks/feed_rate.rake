task feed_rate: :environment do
  response = HTTParty.get("#{ENV["RATES_DOMAIN"]}?key=#{ENV["API_KEY"]}")
  rates = response['rates']
  base_currency_id = Currency.find_by(code:response['base']).id
  rates.each do |code,rate|
    Rate.create!(base_currency_id: base_currency_id, currency_id: Currency.find_by(code:code).id, rate: rate)
  end
end