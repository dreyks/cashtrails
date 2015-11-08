class CashTrailsModel < ActiveRecord::Base
  self.abstract_class = true
  establish_connection :sqlite
end
