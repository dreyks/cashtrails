class CashTrailsModel < ActiveRecord::Base
  self.abstract_class = true
  establish_connection "sqlite_#{Rails.env}".to_sym

  def self.select_user_db(db_path)
    db_path ||= 'db/bare.sqlite3'

    connection_config = configurations["sqlite_#{Rails.env}"].clone
    if connection_config['database'] != db_path
      connection_config['database'] = db_path
      establish_connection connection_config
    end

    true
  end

  # bare.sqlite3 is a skeleton only and must not contain any rows
  def readonly?
    return false if Rails.env.test?

    self.class.connection.instance_variable_get(:@config)[:database].include? 'bare'
  end
end
