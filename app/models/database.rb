class Database < ActiveRecord::Base
  after_destroy :remove_file

  def file=(uploaded_file)
    self.name ||= SecureRandom.hex(4)
    FileUtils.cp(uploaded_file, file_path)
  end

  def file_path
    folder = ENV['OPENSHIFT_DATA_DIR'] || Rails.root.join('db')
    "#{folder}/#{name}.sqlite3"
  end

  private

  def remove_file
    FileUtils.rm file_path
  rescue Errno::ENOENT
  end
end
