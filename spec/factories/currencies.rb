FactoryGirl.define do
  factory :currency, aliases: [:source_currency, :source_currency_foreign, :target_currency, :target_currency_foreign] do
    sequence(:currencyCode) { |n| ('AAA'...'ZZZ').first(n).last }

    initialize_with { Currency.find_or_create_by(currencyCode: currencyCode) }
  end
end
