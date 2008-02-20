# Include hook code here
if RAILS_GEM_VERSION == "2.0.2"
  require File.dirname(__FILE__) + '/lib/markaby_rails2_patch.rb'
end