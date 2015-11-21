FactoryGirl.define do
  factory :record do
    factory :record_with_tags do
      after(:create) do |record, _e|
        create_list(:tag, 5, record: record)
      end
    end
  end
end
