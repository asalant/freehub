# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true
config.action_view.cache_template_loading            = true

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host                  = "http://assets.example.com"

ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  :domain             => "bikekitchen.org",
  :perform_deliveries => true,
  :address            => 'smtp.ey02.engineyard.com',
  :port               => 25
}

SITE_URL = 'http://freehub-staging.bikekitchen.org'