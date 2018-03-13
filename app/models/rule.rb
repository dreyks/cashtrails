class Rule < ApplicationRecord
  belongs_to :importer
  has_many :effects

  scope :by_user, ->(user) { joins(:importer).merge(Importer.by_user(user)) }
end
