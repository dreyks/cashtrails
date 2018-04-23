class TagMinusOne < CashTrailsModel
  self.table_name = 'recordTags'

  belongs_to :record, foreign_key: :recordID, inverse_of: :tag_minus_one

  default_scope { where(tagRelaxedOrderOrMinusOne: -1, tagIDOrInvalid: 0) }
end
