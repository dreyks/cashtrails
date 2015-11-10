class CreateImporters < ActiveRecord::Migration
  def change
    create_table :importers do |t|
      t.references :user
      t.string :name
      t.string :regex

      t.timestamps null: false
    end
  end
end
