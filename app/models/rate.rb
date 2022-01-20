class Rate < ApplicationRecord
  validates :rate, presence: true
  validates :rate, uniqueness: true
  validates :rate, :numericality => { :greater_than => 0}

  belongs_to :base_currency, class_name: "Currency"
  belongs_to :currency
end
