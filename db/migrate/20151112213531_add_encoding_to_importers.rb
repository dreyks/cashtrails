class AddEncodingToImporters < ActiveRecord::Migration
  def change
    add_column :importers, :encoding, :string
  end
end
