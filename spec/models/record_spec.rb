require 'rails_helper'

describe Record do
  describe 'custom setters' do
    it 'set correct local and gmt date/time' do
      record = Record.new(date: '22.10.2015 21:01'.in_time_zone('Europe/Kiev'))
      expect(record.localDate).to eq 20151022
      expect(record.localTime).to eq 210100
      expect(record.gmtDate).to eq 20151022
      expect(record.gmtTime).to eq 180100
    end

    it 'leaves only first currency if second currency is same' do
      data_hash = {
        currency1IDOrInvalid: 20,
        amount1: 612.93,
        currency2IDOrInvalid: 20,
        amount2: -612.93
      }
      record = Record.new(data_hash)

      expect(record.currency1IDOrInvalid).not_to be_nil
      expect(record.amount1).not_to be_nil
      expect(record.currency2IDOrInvalid).to be_nil
      expect(record.amount2).to be_nil
    end

    it 'handle floats as `amount` fields' do
      record = Record.new(
        source_amount: 611.93,
        source_foreign_amount: 611.93,
        source_foreign_currency_id: 20
      )

      expect(record.amount1).to eq 61193
      expect(record.amount2).to eq 61193
    end
  end
end
