FactoryGirl.define do
  factory :pumb_importer, class: Importer do
    user
    name 'pumb'
    date_field 'Дата операції'
    amount_field 'Сума'
    foreign_amount_field 'Сума у валюті операції'
    description_field 'Опис'
  end
end
