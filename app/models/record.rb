class Record < CashTrailsModel
  KIND_EXPENSE = 0
  KIND_INCOME = 1
  KIND_TRANSFER = 2
  KIND_ADJUSTMENT = 3

  attribute :amount1, :amount, zeroed_nil: true
  attribute :amount2, :amount, zeroed_nil: true
  attribute :amount3, :amount, zeroed_nil: true
  attribute :amount4, :amount, zeroed_nil: true

  attribute :sample, :integer, zeroed_nil: true
  attribute :kind, :integer, zeroed_nil: true
  attribute :currency1IDOrInvalid, :integer, zeroed_nil: true
  attribute :currency2IDOrInvalid, :integer, zeroed_nil: true
  attribute :currency3IDOrInvalid, :integer, zeroed_nil: true
  attribute :currency4IDOrInvalid, :integer, zeroed_nil: true
  attribute :account1IDOrInvalid, :integer, zeroed_nil: true
  attribute :account2IDOrInvalid, :integer, zeroed_nil: true
  attribute :groupIDOrInvalid, :integer, zeroed_nil: true
  attribute :partyIDOrInvalid, :integer, zeroed_nil: true
  attribute :hasForeignAmount1, :integer, zeroed_nil: true
  attribute :hasForeignAmount2, :integer, zeroed_nil: true
  attribute :tagCount, :integer, zeroed_nil: true
  attribute :fileCount, :integer, zeroed_nil: true

  alias_attribute :source_amount, :amount1
  alias_attribute :source_currency_id, :currency1IDOrInvalid
  alias_attribute :source_foreign_amount, :amount2
  alias_attribute :source_foreign_currency_id, :currency2IDOrInvalid
  alias_attribute :target_amount, :amount3
  alias_attribute :target_currency_id, :currency3IDOrInvalid
  alias_attribute :target_foreign_amount, :amount4
  alias_attribute :target_foreign_currency_id, :currency4IDOrInvalid
  alias_attribute :kind, :recordKind

  belongs_to :source_account, class_name: 'Account', foreign_key: :account1IDOrInvalid
  belongs_to :target_account, class_name: 'Account', foreign_key: :account2IDOrInvalid, required: false

  belongs_to :source_currency,         class_name: 'Currency', foreign_key: :currency1IDOrInvalid
  belongs_to :source_currency_foreign, class_name: 'Currency', foreign_key: :currency2IDOrInvalid, required: false
  belongs_to :target_currency,         class_name: 'Currency', foreign_key: :currency3IDOrInvalid, required: false
  belongs_to :target_currency_foreign, class_name: 'Currency', foreign_key: :currency4IDOrInvalid, required: false

  has_one :tag_minus_one, foreign_key: :recordID, inverse_of: :record, dependent: :delete
  has_many :records_tags, foreign_key: :recordID, inverse_of: :record, dependent: :delete_all
  has_many :tags, through: :records_tags, inverse_of: :records

  belongs_to :group, foreign_key: :groupIDOrInvalid, required: false
  belongs_to :party, foreign_key: :partyIDOrInvalid, required: false

  has_one :file_minus_one, foreign_key: :recordID, inverse_of: :record, dependent: :delete

  validates_presence_of :source_amount
  validates_presence_of :source_currency
  validates_presence_of :target_amount, if: :transfer?
  validates_presence_of :target_currency, if: :transfer?
  validate :validate_amount_sign
  validate :validate_foreign_amounts

  after_initialize :sanitize, if: :new_record?
  before_save :set_modification_timestamp, if: :changed?
  before_create :generate_uuid, :set_timestamps, :build_tag_minus_one, :build_file_minus_one, :init_not_inited

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
    Utils.format_money(source_amount, source_currency).tap do |out|
      out << " (#{Utils.format_money(source_foreign_amount, source_currency_foreign)})" if source_currency_foreign
    end
  end

  def target_amount_text
    return unless transfer?

    Utils.format_money(target_amount, target_currency).tap do |out|
      out << " (#{Utils.format_money(target_foreign_amount, target_currency_foreign)})" if target_currency_foreign
    end
  end

  def occured_at
    DateTime.parse("#{localDate}#{format('%06d', localTime)}")
  end

  def occured_at=(v)
    self.date = Time.parse(v)
  end

  private

  # Sanity checks on currencies and amounts
  def sanitize
    fix_amount_sign
    fix_foreign_currency
    fix_foreign_amount
  end

  # make both amounts negative if at least one of them is
  def fix_amount_sign
    return unless amount_sign_mismatch?
    assign_attributes(source_foreign_amount: -source_foreign_amount)
  end

  def fix_foreign_currency
    source_currency_id&.nonzero? && source_currency_id == source_foreign_currency_id or return

    # unset foreign currency if same with main currency
    assign_attributes(source_foreign_amount: nil, source_foreign_currency_id: nil)
  end

  def fix_foreign_amount
    self.hasForeignAmount1 = true if source_foreign_amount
    self.hasForeignAmount2 = true if target_foreign_amount
  end

  def validate_amount_sign
    return unless amount_sign_mismatch?

    errors.add(:base, 'Amount signs mismatch')
  end

  def validate_foreign_amounts
    if (source_foreign_amount && !hasForeignAmount1) || (target_foreign_amount && !hasForeignAmount2)
      errors.add(:base, 'Foreign amounts flag mismatch')
    end
  end

  def amount_sign_mismatch?
    return unless source_foreign_amount

    source_amount.positive? != source_foreign_amount.positive?
  end

  def generate_uuid
    self.recordUUID = SecureRandom.uuid.tr('-', '')
  end

  def set_timestamps
    self.creationTimestamp = self.modificationTimestamp = Time.now.to_i
  end

  def set_modification_timestamp
    self.modificationTimestamp = Time.now.to_i
  end

  def init_not_inited
    attrs = @attributes.send(:attributes)
    attrs.each do |attr_name, attr|
      next if attr_name == self.class.primary_key
      next if attr.changed?

      value = case attr.type
              when ActiveModel::Type::Integer, ActiveModel::Type::Float, Type::ZeroedNil
                0
              when ActiveModel::Type::String
                ''
              end

      attrs[attr_name] = attr.with_value_from_user(value)
    end
    self
  end
end
