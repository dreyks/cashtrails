FactoryGirl.define do
  factory :importer_session do
    importer
    user
    account
    file ''

    factory :importer_session_with_items do
      transient do
        items_count 5
      end

      after(:create) do |session, evaluator|
        create_list(:importer_session_item, evaluator.items_count, importer_session: session)
      end
    end
  end
end
