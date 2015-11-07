class User < ActiveRecord::Base
  devise :database_authenticatable, :rememberable

  def db=(db_name)
    if db
      # TODO: move this to separate entity
      begin
        FileUtils.rm Rails.root.join('db', "#{db}.sqlite3")
      rescue Errno::ENOENT
      end
    end

    super(db_name)
  end
end
