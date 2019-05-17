class CreateTrackinglists < ActiveRecord::Migration[5.2]
  def change
    create_table :trackinglists do |t|
      t.integer :user_id
      t.text :racket_id
      t.timestamps
    end
  end
end
