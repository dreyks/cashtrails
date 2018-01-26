class AddColumnSeparatorToImporter < ActiveRecord::Migration[5.1]
  def change
    add_column :importers, :column_separator, :string, default: ','
  end
end
