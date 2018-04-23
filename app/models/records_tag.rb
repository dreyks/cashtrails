class RecordsTag < CashTrailsModel
  self.table_name = 'recordTags'

  belongs_to :record, foreign_key: :recordID, inverse_of: :records_tags, counter_cache: :tagCount
  belongs_to :tag, foreign_key: :tagIDOrInvalid, inverse_of: :records_tags

  default_scope { where.not(tagRelaxedOrderOrMinusOne: -1) }

  before_save :set_order

  private

  def set_order
    self.tagRelaxedOrderOrMinusOne = record.records_tags.to_a.find_index(self)
  end
end
