FactoryBot.define do
  factory :record do
    source_account
    target_account
    source_currency
    source_currency_foreign
    target_currency
    target_currency_foreign

    factory :record_with_tags do
      after(:create) do |record, _e|
        create_list(:tag, 5, record: record)
      end
    end
  end
end
