require 'rails_helper'

describe Importer do

  it 'has a valid factory' do
    expect(build(:importer)).to be_valid
  end

  describe '#parse' do
    subject { importer.send(:parse, sample_file).first }

    context 'pumb' do
      let(:importer) { create(:importer, :pumb) }
      let(:sample_file) { File.new(Rails.root.join('spec/support/pumb_sample.csv')) }
      let(:sample_data) do
        {
          date_field: '22.10.2015 21:01',
          description_field: 'Покупка (оплата) з використанням платіжної кратки (по карте: *8314) AUCHAN015 KIYEV UA',
          amount_field: '612,93 UAH',
          foreign_amount_field: '-612,93 UAH'
        }
      end

      it { is_expected.to eq sample_data }
    end

    context 'ukrsib' do
      let(:importer) { create(:importer, :ukrsib) }
      let(:sample_file) { File.new(Rails.root.join('spec/support/ukrsib_sample.csv')) }
      let(:sample_data) do
        {
          date_field: '08.11.2017 08:52',
          description_field: 'payment for services rendered oninvoice RUB-1706 dated 31.10.2017Agr. No.68/RUB 10.04.2017FOP R. B. Usherenko/000009196380621R W CONSULTING INC.679 TITICUS RDNO',
          amount_field: '4251.00 USD'
        }
      end

      it { is_expected.to eq sample_data }
    end
  end

  describe '#convert_to_record_data' do
    let(:importer) { create(:importer, :pumb) }
    let(:sample_data) do
      {
        date_field: '22.10.2015 21:01',
        description_field: 'Покупка (оплата) з використанням платіжної кратки (по карте: *8314) AUCHAN015 KIYEV UA',
        amount_field: '612,93 UAH',
        foreign_amount_field: '-612,93 UAH'
      }
    end
    let(:currency_uah) { create(:currency, currencyCode: 'UAH') }

    it 'returns data hash to create a Record' do
      cmp = {
        note: sample_data[:description_field],
        source_currency_id: currency_uah.id,
        source_amount: 612.93,
        source_foreign_currency_id: currency_uah.id,
        source_foreign_amount: -612.93,
        date: '22.10.2015 21:01'.in_time_zone('Europe/Kiev')
      }
      expect(importer.send(:convert_to_record_data, sample_data)).to eq cmp
    end
  end
end
