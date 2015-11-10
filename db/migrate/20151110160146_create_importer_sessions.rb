class CreateImporterSessions < ActiveRecord::Migration
  def change
    create_table :importer_sessions do |t|
      t.belongs_to :importer
      t.belongs_to :user
      t.belongs_to :account

      t.timestamps null: false
    end
  end
end
