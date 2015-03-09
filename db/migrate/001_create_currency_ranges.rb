class CreateCurrencyRanges < ActiveRecord::Migration
  def self.up
    create_table :currency_ranges, :force => true do |t|
      t.column :currency, :string
      t.column :start_date, :datetime
      t.column :due_date, :datetime
      t.column :value, :float, :null => false, :default => 0
    end
  end

  def self.down
    drop_table :currency_ranges
  end
end
