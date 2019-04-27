task :export do
  tmp_dir = "tmp/export"
  FileUtils.rm_r tmp_dir

  backup_dir = "#{tmp_dir}/Backup"
  FileUtils.mkdir_p backup_dir
  FileUtils.cp 'db/1.sqlite3', "#{backup_dir}/Main.db"
  Dir.chdir(tmp_dir) do
    `zip -r 1.cashtrails Backup`
  end
end
