FactoryBot.define do
  factory :importer do
    user
    name 'Generic importer'

    trait :pumb do
      name 'pumb'
      date_field 'Дата операції'
      amount_field 'Сума'
      foreign_amount_field 'Сума у валюті операції'
      description_field 'Опис'
    end

    trait :ukrsib do
      name 'ukrsib'
      encoding 'cp1251'
      column_separator ';'
      date_field 'Дата операции'
      amount_field '-Дебет|Кредит&Валюта'
      description_field 'Назначение платежа'
    end
  end
end
