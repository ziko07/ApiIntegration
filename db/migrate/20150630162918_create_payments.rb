class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.string :first_name
      t.string :last_name
      t.string :last4
      t.decimal :amount, precision: 12, scale: 3
      t.boolean :success
      t.string :authorization_code

      t.timestamps null: false
    end
  end
end
