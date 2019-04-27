class AddChangeSignEffect < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!

  def up
    execute <<~SQL
      ALTER TYPE effect ADD VALUE 'change_source_sign' BEFORE 'remove_record';
    SQL
    execute <<~SQL
      ALTER TYPE effect ADD VALUE 'change_target_sign' BEFORE 'remove_record';
    SQL
  end

  def down
    ActiveRecord::Base.transaction do
      Effect.where(type: 'change_sign').destroy_all
      execute <<~SQL
        CREATE TYPE effect_new AS ENUM ('change_kind', 'change_source_account', 'change_target_account', 'add_tag', 'change_party', 'change_group', 'remove_record');
      SQL
      change_column :effects, :type, 'effect_new USING type::text::effect_new'
      execute <<~SQL
        DROP TYPE effect;
        ALTER TYPE effect_new RENAME TO effect;
      SQL
    end
  end
end
