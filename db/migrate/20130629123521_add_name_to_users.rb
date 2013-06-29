class AddNameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :name, :string, :unique => true, :null => false, :default => ''
  end
end
