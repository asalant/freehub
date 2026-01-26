require 'hoptoad_notifier/rails'
HoptoadNotifier.configure do |config|
  config.api_key = ENV['HOPTOAD_API_KEY']
end
