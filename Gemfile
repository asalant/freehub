source 'https://rubygems.org'

gem "rails", "2.3.17"
gem "pg", "0.18.4"
gem "authorization", github:  "asalant/rails-authorization-plugin"
gem 'json', '1.7.7' # (CVE-2013-026) Can remove once rails depends on > 1.7.6
gem 'haml', "3.0.25"
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
