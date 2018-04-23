class Database < ActiveRecord::Base
  after_destroy :remove_file
  after_create :save_file

  attr_accessor :file

  def file_path
    folder = ENV['OPENSHIFT_DATA_DIR'] || Rails.root.join('db')
    "#{folder}/#{name || SecureRandom.hex(4)}.sqlite3"
  end

  private

  def save_file
    file or return

    FileUtils.cp(file, file_path)
  end

  def remove_file
    FileUtils.rm file_path
  rescue Errno::ENOENT
    nil
  end
end
