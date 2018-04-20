class RecordTagZero < CashTrailsModel
  self.table_name = 'recordTags'

  belongs_to :record, foreign_key: :recordID, inverse_of: :record_tag_zero

  default_scope { where(tagRelaxedOrderOrMinusOne: -1, tagIDOrInvalid: 0) }
end
