class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.string :name
      t.integer :calories
      t.decimal :price
      t.integer :category_id
    end
  end
end
