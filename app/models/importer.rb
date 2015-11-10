class Importer < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :user, :name

  alias_attribute :to_s, :name
end
