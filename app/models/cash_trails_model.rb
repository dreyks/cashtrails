class CashTrailsModel < ActiveRecord::Base
  self.abstract_class = true
  establish_connection :cash_trails_sqlite
end