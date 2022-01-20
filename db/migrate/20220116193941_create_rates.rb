class CreateRates < ActiveRecord::Migration[6.1]
  def change
    create_table :rates do |t|
      t.integer :base_currency_id
      t.references :currency, null: false, foreign_key: true
      t.float :rate

      t.timestamps
    end
  end
end
