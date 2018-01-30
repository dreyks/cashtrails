class CreateActions < ActiveRecord::Migration[5.1]
  def up
    execute <<~SQL
      CREATE TYPE effect AS ENUM ('source_account', 'target_account', 'tag', 'party', 'remove');
    SQL

    create_table :actions do |t|
      t.belongs_to :rule
      t.column :effect, :effect
      t.string :value

      t.timestamps
    end
  end

  def down
    drop_table :actions

    execute <<~SQL
      DROP TYPE effect;
    SQL
  end
end
