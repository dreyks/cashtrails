class ChangeImporters < ActiveRecord::Migration
  def change
    change_table :importers do |t|
      t.rename :regex, :date_field
      t.string :amount_field
      t.string :foreign_amount_field
      t.string :description_field
    end
  end
end
