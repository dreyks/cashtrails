class RecordsTag < CashTrailsModel
  self.table_name = 'recordTags'

  belongs_to :record, foreign_key: :recordID, inverse_of: :records_tags
  belongs_to :tag, foreign_key: :tagIDOrInvalid, inverse_of: :records_tags
end
