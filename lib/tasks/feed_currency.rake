task feed_currency: :environment do
  response = HTTParty.get("#{ENV["CURRENCIES_API"]}?key=#{ENV["API_KEY"]}")
  currencies = response['currencies']
  currencies.each do |code,name|
    Currency.create!(name: name, code: code)
  end
end