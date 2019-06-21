class CreateRackets < ActiveRecord::Migration[5.2]
  def change
    create_table :rackets do |t|
      t.string :name
      t.string :label
      t.integer :weight , :default => 0
      t.integer :price
      t.text :spec
      t.string :profile
      t.string :fb_url
      t.integer :lunched , :default => 0
      t.timestamps
    end
  end
end
