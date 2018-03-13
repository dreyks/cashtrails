class Tag < CashTrailsModel
  has_many :records_tags, foreign_key: :tagIDOrInvalid, inverse_of: :tag
  has_many :records, through: :records_tags, inverse_of: :tags

  def to_s
    name
  end
end
