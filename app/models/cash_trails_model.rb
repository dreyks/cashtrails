class CashTrailsModel < ActiveRecord::Base
  self.abstract_class = true
  establish_connection "sqlite_#{Rails.env}".to_sym
end
