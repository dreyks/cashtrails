class Record < CashTrailsModel
  KIND_EXPENSE = 0
  KIND_INCOME = 1
  KIND_TRANSFER = 2
  KIND_ADJUSTMENT = 3

  # fields where 0 has to be treated as +nil+
  NILLED_ZEROS = [:currency1IDOrInvalid, :currency2IDOrInvalid, :currency3IDOrInvalid,
                  :currency4IDOrInvalid, :account2IDOrInvalid, :groupIDOrInvalid].freeze

  alias_attribute :source_currency_id,          :currency1IDOrInvalid
  alias_attribute :source_foreign_currency_id,  :currency2IDOrInvalid
  alias_attribute :target_currency_id,          :currency3IDOrInvalid
  alias_attribute :target_foreign_currency_id,  :currency4IDOrInvalid
  alias_attribute :kind, :recordKind

  belongs_to :source_account, class_name: 'Account', foreign_key: :account1IDOrInvalid
  belongs_to :target_account, class_name: 'Account', foreign_key: :account2IDOrInvalid, required: false

  belongs_to :source_currency,         class_name: 'Currency', foreign_key: :currency1IDOrInvalid
  belongs_to :source_currency_foreign, class_name: 'Currency', foreign_key: :currency2IDOrInvalid, required: false
  belongs_to :target_currency,         class_name: 'Currency', foreign_key: :currency3IDOrInvalid, required: false
  belongs_to :target_currency_foreign, class_name: 'Currency', foreign_key: :currency4IDOrInvalid, required: false

  has_many :records_tags, foreign_key: :recordID
  has_many :tags, through: :records_tags

  belongs_to :group, foreign_key: :groupIDOrInvalid, required: false
  belongs_to :party, foreign_key: :partyIDOrInvalid, required: false

  after_initialize :convert_zeros_to_nils, if: :persisted?
  after_initialize :sanitize, unless: :persisted?
  before_save :convert_nils_to_zeros
  before_create :generate_uuid

  # if this has to be changed to a named scope, account for the need of
  #   importer_session.items.includes(record: [_all_this_includes_here_])
  def self.default_scope
    includes(
      :source_account,
      :target_account,
      :source_currency,
      :source_currency_foreign,
      :target_currency,
      :target_currency_foreign,
      :tags,
      :group
    )
  end

  def self.kinds
    {
      KIND_EXPENSE => 'Expense',
      KIND_INCOME => 'Income',
      KIND_TRANSFER => 'Transfer',
      KIND_ADJUSTMENT => 'Ballance adjustment'
    }
  end

  # Helper methods to assign Floats
  # All amounts are stored as Fixnum
  %w[source source_foreign target target_foreign].each_with_index do |m, i|
    define_method "#{m}_amount" do                  # def source_amount
      send("amount#{i + 1}").to_f / 100             #   amount1.to_f / 100
    end                                             # end

    define_method "#{m}_amount=" do |amt|           # def source_amount=(amt)
      amt = (amt * 100).round if amt                #   amt = (amt * 100).round if amt
      send("amount#{i + 1}=", amt)                  #   self.amount1 = amt
    end                                             # end
  end

  # Helper method to assign all date-related fields at once
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
      out << " (#{Utils.format_money(amount2, source_currency_foreign)})" if source_currency_foreign
    end
  end

  def target_amount_text
    return unless transfer?

    Utils.format_money(amount3, target_currency).tap do |out|
      out << " (#{Utils.format_money(amount4, target_currency_foreign)})" if target_currency_foreign
    end
  end

  def occured_at
    DateTime.parse("#{localDate}#{format('%06d', localTime)}")
  end

  private

  # Sanity checks on currencies and amounts
  def sanitize
    check_amount_sign
    check_kind

    return if source_currency_id != source_foreign_currency_id

    # unset foreign currency if same with main currency
    assign_attributes(source_foreign_amount: nil, source_foreign_currency_id: nil)
  end

  # make both amounts negative if at least one of them is
  def check_amount_sign
    a1 = source_amount
    a2 = source_foreign_amount
    assign_attributes(source_amount: -a1.abs, source_foreign_amount: -a2.abs) if a1 && a2 && (a1 < 0 || a2 < 0)
  end

  def check_kind; end

  def convert_zeros_to_nils
    NILLED_ZEROS.each do |c|
      if read_attribute(c) && read_attribute(c).zero?
        write_attribute(c, nil)
        clear_attribute_change(c)
      end
    end
  end

  def convert_nils_to_zeros
    NILLED_ZEROS.each do |c|
      write_attribute(c, 0) if read_attribute(c).nil?
    end
  end

  def generate_uuid
    self.recordUUID = SecureRandom.uuid.tr('-', '')
  end
end
