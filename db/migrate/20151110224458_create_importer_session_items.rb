class CreateImporterSessionItems < ActiveRecord::Migration
  def change
    create_table :importer_session_items do |t|
      t.belongs_to :importer_session
      t.belongs_to :record

      t.timestamps null: false
    end
  end
end
