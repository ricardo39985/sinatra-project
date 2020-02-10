class AddUserForeignKeyToCars < ActiveRecord::Migration
  def change
    add_foreign_key :cars, :users
  end
end
