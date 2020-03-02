class CreateCars < ActiveRecord::Migration
  def change
    create_table :cars do |t|
      t.string :make
      t.string :model
      t.string :year
      t.string :color
      t.string :transmission
      t.text :options
      t.text :specs
      t.integer :mileage
      t.integer :user_id      
    end
  end
end
