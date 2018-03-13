class CreateEffects < ActiveRecord::Migration[5.1]
  def up
    execute <<~SQL
      CREATE TYPE effect AS ENUM ('change_kind', 'change_source_account', 'change_target_account', 'add_tag', 'change_party', 'change_group', 'remove_record');
    SQL

    create_table :effects do |t|
      t.belongs_to :rule
      t.column :type, :effect
      t.string :value

      t.timestamps
    end
  end

  def down
    drop_table :effects

    execute <<~SQL
      DROP TYPE effect;
    SQL
  end
end
