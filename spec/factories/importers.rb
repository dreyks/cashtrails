FactoryGirl.define do
  factory :importer do
    user
    name 'Generic importer'

    factory :pumb_importer do
      name 'pumb'
      date_field 'Дата операції'
      amount_field 'Сума'
      foreign_amount_field 'Сума у валюті операції'
      description_field 'Опис'
    end
  end
end
