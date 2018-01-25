require 'csv'

class Importer < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :user, :name

  alias_attribute :to_s, :name

  before_save do
    self.encoding ||= 'utf-8'
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

  # Converts amount_field to source_amount + source_currency_id
  # foreign_amount_field to source_foreign_amount + source_foreign_currency_id
  def extract_amount(key, value)
    amount_attr = "source_#{key.to_s.sub('_field', '')}".to_sym
    currency_id_attr = amount_attr.to_s.sub('amount', 'currency_id').to_s.to_sym

    out = {
      amount_attr => nil,
      currency_id_attr => nil
    }

    amount, currency_code = value.split(' ')

    return out unless (currency = Currency.where(currencyCode: currency_code).first)

    out.update(amount_attr => amount.tr(',', '.').to_f, currency_id_attr => currency.id)
  end
end
