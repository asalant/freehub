# Patch for MySQL 8.0 compatibility with Rails 2.3
# MySQL 8.0 requires PRIMARY KEY columns to be NOT NULL
# Rails 2.3's MysqlAdapter uses "DEFAULT NULL" which causes errors
#
# See: https://github.com/rails/rails/pull/13247

module ActiveRecord
  module ConnectionAdapters
    class MysqlAdapter
      NATIVE_DATABASE_TYPES[:primary_key] = "int(11) NOT NULL auto_increment PRIMARY KEY"
    end
  end
end
