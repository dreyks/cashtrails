class CreateDatabases < ActiveRecord::Migration
  def change
    create_table :databases do |t|
      t.belongs_to :user
      t.string :name
      t.timestamps null: false
    end
  end
end
