source 'https://rubygems.org'

gem "rails", "2.3.17"
gem "mysql"
gem "tzinfo", "~> 0.3.61"  # See https://github.com/asalant/freehub/pull/56
gem 'authorization', git:  "https://github.com/asalant/rails-authorization-plugin"
gem 'json', '1.7.7' # (CVE-2013-026) Can remove once rails depends on > 1.7.6
gem 'haml', "5.1.2"
gem 'googlecharts', "1.6.0"
gem 'calendar_date_select', "1.16.1"
gem "acts-as-taggable-on", "2.0.6"
gem "newrelic_rpm"
gem 'hoptoad_notifier'
gem 'validates_email_format_of'
gem 'rdoc'

group :development, :test do
  gem 'annotate'
  gem 'test-unit'
  gem 'thoughtbot-shoulda'
end

group :production do
  gem 'unicorn'
end
