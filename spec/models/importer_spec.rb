require 'rails_helper'

describe Importer do
  let(:pumb_importer) { create(:pumb_importer) }
  let(:sample_data) do
    {
      date_field: '22.10.2015 21:01',
      description_field: 'Покупка (оплата) з використанням платіжної кратки (по карте: *8314) AUCHAN015 KIYEV UA',
      amount_field: '612,93 UAH',
      foreign_amount_field: '-612,93 UAH'
    }
  end

  describe '#call' do
    let(:sample_file) { File.open(Rails.root.join('spec/support/pumb_sample.csv')) }

    after(:each) { sample_file.close if sample_file.respond_to? :close }

    it 'parses csv files with headers' do
      expect(pumb_importer.call(sample_file)).to eq [sample_data]
    end
  end

  describe '#parse_record_data' do
    let(:currency_uah) { create(:currency_uah) }
    it 'returns data hash to create a Record' do
      cmp = {
        note: sample_data[:description_field],
        currency1IDOrInvalid: currency_uah.id,
        amount1: 612.93,
        currency2IDOrInvalid: currency_uah.id,
        amount2: -612.93,
        date: '22.10.2015 21:01'.in_time_zone('Europe/Kiev')
      }
      expect(pumb_importer.parse_record_data(sample_data)).to eq cmp
    end
  end
end
