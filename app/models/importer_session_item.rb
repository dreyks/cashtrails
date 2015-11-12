class ImporterSessionItem < ActiveRecord::Base
  belongs_to :importer_session
  belongs_to :record
end
