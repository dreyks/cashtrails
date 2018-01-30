class CreateRules < ActiveRecord::Migration[5.1]
  def change
    create_table :rules do |t|
      t.belongs_to :importer
      t.string :trigger, null: false

      t.timestamps
    end
  end
end
