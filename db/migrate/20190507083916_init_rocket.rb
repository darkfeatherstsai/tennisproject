class InitRocket < ActiveRecord::Migration[5.2]
  def change
    create_table :trackinglists do |t|
      t.integer :id
      t.string :date
      t.integer :user_id
      t.array :rocket_id
    end
    create_table :rockets do |t|
      t.integer :id
      t.string :name
      t.string :label
      t.integer :weight
      t.integer :price
      t.text :spec
      t.string :profile
      t.string :location
      t.string :url
    end
  end
end
