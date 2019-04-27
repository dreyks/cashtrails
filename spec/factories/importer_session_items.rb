FactoryBot.define do
  factory :importer_session_item do
    transient { record_factory { :record } }

    importer_session
    record { build(record_factory) }

    after(:create) { |item| item.record.save! }
  end
end
