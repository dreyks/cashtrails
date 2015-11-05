class RecordsTag < ActiveRecord::Base
  self.table_name = 'recordTags'

  belongs_to :record, foreign_key: :recordID
  belongs_to :tag, foreign_key: :tagIDOrInvalid
end
