class CashTrailsModel < ActiveRecord::Base
  self.abstract_class = true
  establish_connection "sqlite_#{Rails.env}".to_sym

  def self.select_user_db(user)
    db_name = (user ? user.database.file_path : false) || 'db/bare.sqlite3'

    connection_config = configurations["sqlite_#{Rails.env}"].clone
    if connection_config['database'] != db_name
      connection_config['database'].replace db_name
      establish_connection connection_config
    end

    true
  end
end
