class CreateRockets < ActiveRecord::Migration[5.2]
  def change
    create_table :rockets do |t|
        t.string :name
        t.string :label
        t.integer :weight
        t.integer :price
        t.text :spec
        t.string :profile
        t.string :location
        t.string :url
        t.timestamps
    end
  end
end
