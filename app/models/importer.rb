require 'csv'

class Importer < ActiveRecord::Base
  belongs_to :user
  has_many :rules

  validates_presence_of :user, :name

  alias_attribute :to_s, :name

  scope :by_user, ->(user) { where(user: user) }

  before_save do
    self.encoding ||= 'utf-8'
  end

  def call(file)
    parse(file).map do |data_hash|
      convert_to_record_data(data_hash)
    end
  end

  private

  def parse(file)
    [].tap do |out|
      # TODO: output encoding needed?
      CSV.foreach(file, headers: true, encoding: encoding, col_sep: column_separator) do |line|
        {}.tap do |item|
          [:date_field, :amount_field, :foreign_amount_field, :description_field].each do |field|
            value = send(field) or next

            item[field] = handle_and(value) do |v|
              handle_or(v) do |field_name|
                field_value = line.fetch(field_name.sub('-', '')) or next

                result = [field_value]
                result.unshift('-') if field_name.starts_with?('-')

                result.join
              end
            end
          end
          out << item
        end
      end
    end
  end

  def handle_and(value)
    value.split('&').map do |v|
      yield v
    end.join ' '
  end

  def handle_or(value)
    value.split('|').each do |v|
      res = yield v
      return res if res
    end
    nil
  end

  def convert_to_record_data(data_hash)
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
