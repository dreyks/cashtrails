FactoryGirl.define do
  factory :currency do
    sequence(:currencyCode) { |n| ('AAA'...'ZZZ').first(n).last }
  end
end
