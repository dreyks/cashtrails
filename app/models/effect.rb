class Effect < ApplicationRecord
  self.inheritance_column = nil

  enum type: {
    change_kind: 'change_kind',
    change_source_account: 'change_source_account',
    change_target_account: 'change_target_account',
    add_tag: 'add_tag',
    change_party: 'change_party',
    change_group: 'change_group',
    change_source_sign: 'change_source_sign',
    change_target_sign: 'change_target_sign',
    remove_record: 'remove_record'
  }

  belongs_to :rule

  scope :by_user, ->(user) { joins(:rule).merge(Rule.by_user(user)) }

  def human_value
    case type
    when 'change_kind'
      Record.kinds[value.to_i]
    when 'change_source_account', 'change_target_account'
      Account.find(value.to_i)
    when 'add_tag'
      Tag.find(value.to_i)
    when 'change_party'
      Party.find(value.to_i)
    when 'change_group'
      Group.find(value.to_i)
    else
      ''
    end
  rescue ActiveRecord::RecordNotFound
    ''
  end

  def value_type
    case type
    when 'change_kind', 'change_source_account', 'change_target_account', 'add_tag', 'change_party', 'change_group'
      :select
    when 'remove_record', 'change_source_sign', 'change_target_sign'
      :hidden
    else
      :string
    end
  end

  def value_opts
    case type
    when 'change_kind'
      {collection: Record.kinds.invert}
    when 'change_source_account', 'change_target_account'
      {collection: Account.all}
    when 'add_tag'
      {collection: Tag.all}
    when 'change_party'
      {collection: Party.all}
    when 'change_group'
      {collection: Group.all}
    else
      {}
    end
  end
end
