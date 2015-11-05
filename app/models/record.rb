class Record < ActiveRecord::Base
  KIND_EXPENSE = 0
  KIND_INCOME = 1
  KIND_TRANSFER = 2
  KIND_ADJUSTMENT = 3

  # fields where 0 has to be treated as +nil+
  NILLED_ZEROS = [:currency1IDOrInvalid, :currency2IDOrInvalid, :currency3IDOrInvalid, :currency4IDOrInvalid, :account2IDOrInvalid, :groupIDOrInvalid]

  belongs_to :source_account, class_name: 'Account', foreign_key: :account1IDOrInvalid
  belongs_to :target_account, class_name: 'Account', foreign_key: :account2IDOrInvalid

  belongs_to :source_currency,         class_name: 'Currency', foreign_key: :currency1IDOrInvalid
  belongs_to :source_currency_foreign, class_name: 'Currency', foreign_key: :currency2IDOrInvalid
  belongs_to :target_currency,         class_name: 'Currency', foreign_key: :currency3IDOrInvalid
  belongs_to :target_currency_foreign, class_name: 'Currency', foreign_key: :currency4IDOrInvalid

  has_many :records_tags, foreign_key: :recordID
  has_many :tags, through: :records_tags

  belongs_to :group, foreign_key: :groupIDOrInvalid

  after_initialize  :convert_zeros_to_nils
  before_save       :convert_nils_to_zeros

  def transfer?
    recordKind == KIND_TRANSFER
  end

  def source_amount_text
    Utils.format_money(amount1, source_currency).tap do |out|
      out << " (#{Utils.format_money(amount2, source_currency_foreign)})" unless amount2.zero?
    end
  end

  def target_amount_text
    return unless transfer?

    Utils.format_money(amount3, target_currency).tap do |out|
      out << " (#{Utils.format_money(amount4, target_currency_foreign)})" unless amount4.zero?
    end
  end

  def occured_at
    DateTime.parse("#{localDate}#{format('%06d', localTime)}")
  end

  private

  def convert_zeros_to_nils
    NILLED_ZEROS.each do |c|
      if read_attribute(c).zero?
        write_attribute(c, nil)
        clear_attribute_changes(c)
      end
    end
  end

  def convert_nils_to_zeros
    NILLED_ZEROS.each do |c|
      write_attribute(c, 0) if read_attribute(c).nil?
    end
  end
end