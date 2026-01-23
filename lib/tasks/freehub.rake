namespace :models do
  desc "Updates model and fixture annotations with database fields"
  task :annotate do
    system 'annotate --delete'
    system 'annotate --position before --exclude tests'
  end
end

namespace :db do
  desc "Clean a MySQL backup for MySQL 8.0 compatibility. Usage: rake db:clean_backup[path/to/backup.sql.gz]"
  task :clean_backup, [:file] => :environment do |t, args|
    backup_file = args[:file] || Dir.glob(Rails.root.join('*.sql.gz')).first

    unless backup_file && File.exist?(backup_file)
      puts "Error: No backup file found. Specify a file: rake db:clean_backup[path/to/file.sql.gz]"
      exit 1
    end

    # Output file replaces .sql.gz with .mysql8.sql.gz
    output_file = backup_file.sub(/\.sql\.gz$/, '.mysql8.sql.gz')

    puts "Cleaning #{backup_file} for MySQL 8.0 compatibility..."

    # Build sed commands for MySQL 8.0 compatibility
    sed_commands = [
      # Remove references to SESSION_VARIABLES (removed in MySQL 8.0)
      '/SESSION_VARIABLES/d',
    ].join('; ')

    cmd = "gunzip -c #{backup_file} | sed '#{sed_commands}' | gzip > #{output_file}"

    success = system(cmd)

    if success
      puts "Created cleaned backup: #{output_file}"
    else
      puts "Error cleaning backup"
      exit 1
    end
  end

  desc "Load a gzipped SQL backup into the local database. Usage: rake db:load_backup[path/to/backup.sql.gz]"
  task :load_backup, [:file] => :environment do |t, args|
    require 'yaml'

    backup_file = args[:file] || Dir.glob(Rails.root.join('*.sql.gz')).first

    unless backup_file && File.exist?(backup_file)
      puts "Error: No backup file found. Specify a file: rake db:load_backup[path/to/file.sql.gz]"
      exit 1
    end

    config = ActiveRecord::Base.configurations[Rails.env]
    database = config['database']
    username = config['username'] || 'root'
    password = config['password']
    host = config['host'] || ENV['DATABASE_HOST'] || 'localhost'

    puts "Loading #{backup_file} into #{database} on #{host}..."

    # Drop and recreate database
    puts "Recreating database #{database}..."
    ActiveRecord::Base.connection.execute("DROP DATABASE IF EXISTS #{database}")
    ActiveRecord::Base.connection.execute("CREATE DATABASE #{database}")
    ActiveRecord::Base.connection.execute("USE #{database}")

    # Build mysql command
    mysql_cmd = "mysql -h #{host} -u #{username}"
    mysql_cmd += " -p#{password}" if password.present?
    mysql_cmd += " #{database}"

    # Load the backup
    cmd = "gunzip -c #{backup_file} | #{mysql_cmd}"
    puts "Running: gunzip -c #{backup_file} | mysql -h #{host} -u #{username} #{database}"

    success = system(cmd)

    if success
      puts "Successfully loaded backup into #{database}"
    else
      puts "Error loading backup"
      exit 1
    end
  end
end