# Don't load anything when running the gems:* tasks.
# Otherwise, airbrake will be considered a framework gem.
# https://thoughtbot.lighthouseapp.com/projects/14221/tickets/629
unless ARGV.any? {|a| a =~ /^gems/}

  require 'airbrake/tasks'

end
