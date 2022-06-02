class AddColToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :request, :string
    add_index :users, :request 
  end
end