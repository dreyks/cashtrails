FactoryBot.define do
  factory :account, aliases: [:source_account, :target_account] do
    name { 'Cash' }
    account_group
  end
end
