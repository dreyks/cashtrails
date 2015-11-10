class User < ActiveRecord::Base
  devise :database_authenticatable, :rememberable

  has_one :database
  has_many :importers
  has_many :importer_sessions

  def database=(db)
    database.destroy if database

    super(db)
  end

  def ==(other)
    id = other.id
  end
end
