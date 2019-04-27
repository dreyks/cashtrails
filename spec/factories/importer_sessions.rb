FactoryBot.define do
  factory :importer_session do
    importer
    user
    account
    file { 'whatever' }

    transient do
      items_count { nil }
    end

    after(:create) do |session, evaluator|
      create_list(:importer_session_item, evaluator.items_count, importer_session: session)
    end
  end
end
