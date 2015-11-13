class Record < CashTrailsModel
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

  after_initialize :convert_zeros_to_nils
  after_initialize :sanitize, unless: :persisted?
  before_save :convert_nils_to_zeros

  def sanitize
    a1 = amount1
    a2 = amount2
    if a1 && a2 && (a1 < 0 || a2 < 0)
      assign_attributes(amount1: -(a1.abs), amount2: -(a2.abs))
    end

    return unless currency1IDOrInvalid == currency2IDOrInvalid

    assign_attributes(amount2: nil, currency2IDOrInvalid: nil)
  end

  def date=(date)
    self.localDate = date.strftime('%Y%m%d').to_i
    self.localTime = date.strftime('%H%M%S').to_i
    self.gmtDate = date.in_time_zone('UTC').strftime('%Y%m%d').to_i
    self.gmtTime = date.in_time_zone('UTC').strftime('%H%M%S').to_i
  end

  def transfer?
    recordKind == KIND_TRANSFER
  end

  def source_amount_text
    Utils.format_money(amount1, source_currency).tap do |out|
      out << " (#{Utils.format_money(amount2, source_currency_foreign)})" if amount2.present?
    end
  end

  def target_amount_text
    return unless transfer?

    Utils.format_money(amount3, target_currency).tap do |out|
      out << " (#{Utils.format_money(amount4, target_currency_foreign)})" if amount4.present?
    end
  end

  def occured_at
    DateTime.parse("#{localDate}#{format('%06d', localTime)}")
  end

  private

  def convert_zeros_to_nils
    NILLED_ZEROS.each do |c|
      if read_attribute(c) && read_attribute(c).zero?
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
