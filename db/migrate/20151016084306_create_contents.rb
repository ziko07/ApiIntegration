class CreateContents < ActiveRecord::Migration
  def change
    create_table :contents do |t|
      t.text :content

      t.timestamps null: false
    end
  end
end
