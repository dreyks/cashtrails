class AddDbToUser < ActiveRecord::Migration
  def change
    add_column :users, :db, :string
  end
end
