require 'csv'

class Importer < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :user, :name

  alias_attribute :to_s, :name

  before_save do
    self.encoding = 'utf-8' unless encoding
  end

  def call(file)
    [].tap do |out|
      # TODO: output encoding needed?
      CSV.foreach(file, headers: true, encoding: encoding) do |line|
        {}.tap do |item|
          [:date_field, :amount_field, :foreign_amount_field, :description_field].each do |field|
            item[field] = line.fetch(send(field))
          end
          out << item
        end
      end
    end
  end

  def parse_record_data(data_hash)
    {}.tap do |record_hash|
      data_hash.each do |key, value|
        case key
        when :description_field
          record_hash[:note] = value
        when :amount_field, :foreign_amount_field
          record_hash.update(extract_amount(key, value))
        when :date_field
          # TODO: configurable time zone
          record_hash[:date] = value.in_time_zone('Europe/Kiev')
        end
      end
    end
  end

  private

  def extract_amount(key, value)
    num = {amount_field: 1, foreign_amount_field: 2}[key]
    res_amount = "amount#{num}".to_sym
    res_currency = "currency#{num}IDOrInvalid".to_sym
    out = {
      res_amount => nil,
      res_currency => nil
    }

    amount, currency_code = value.split(' ')

    return out unless (currency = Currency.where(currencyCode: currency_code).first)

    out.update(res_amount => amount.tr(',', '.').to_f, res_currency => currency.id)
  end
end
