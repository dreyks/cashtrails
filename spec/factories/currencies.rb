FactoryGirl.define do
  factory :currency do
    sequence(:currencyCode) { |n| ('AAA'...'ZZZ').first(n).last }

    initialize_with { Currency.find_or_create_by(currencyCode: currencyCode) }
  end
end
