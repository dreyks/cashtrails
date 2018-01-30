class Rule < ApplicationRecord
  belongs_to :importer
  has_many :actions

  scope :by_user, ->(user) { joins(:importer).merge(Importer.by_user(user)) }
end
