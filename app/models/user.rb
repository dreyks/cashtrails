class User < ActiveRecord::Base
  devise :database_authenticatable, :rememberable

  has_one :database

  def database=(db)
    database.destroy if database

    super(db)
  end
end
