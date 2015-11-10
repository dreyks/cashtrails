class ImporterSession < ActiveRecord::Base
  attr_accessor :file

  belongs_to :importer
  belongs_to :user
  belongs_to :account

  validates_presence_of :importer, :user, :account
end
