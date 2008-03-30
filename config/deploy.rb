# Please install the Engine Yard Capistrano gem
# gem install eycap --source http://gems.engineyard.com

require 'eycap/recipes'

# =============================================================================
# ENGINE YARD REQUIRED VARIABLES
# =============================================================================
# You must always specify the application and repository for every recipe. The
# repository must be the URL of the repository you want this recipe to
# correspond to. The :deploy_to variable must be the root of the application.

set :keep_releases, 5
set :application,   'freehub'
set :repository,    'http://bikekitchen-svn.cvsdude.com/membership/freehub_for_all/trunk'
set :scm_username,  ''
set :scm_password,  ''
set :user,          'freehub'
set :password,      'iv2ly4ue'
set :deploy_to,     "/data/#{application}"
set :deploy_via,    :filtered_remote_cache
set :repository_cache,    "/var/cache/engineyard/#{application}"
set :monit_group,   'freehub'
set :scm,           :subversion


set :production_database,'freehub_production'
set :production_dbhost, 'mysql50-4-master'


set :staging_database,'freehub_staging'
set :staging_dbhost, 'mysql50-staging-1'


set :dbuser, 'freehub_db'
set :dbpass, 'vb83d7au'

# comment out if it gives you trouble. newest net/ssh needs this set.
ssh_options[:paranoid] = false



# =============================================================================
# ROLES
# =============================================================================
# You can define any number of roles, each of which contains any number of
# machines. Roles might include such things as :web, or :app, or :db, defining
# what the purpose of each machine is. You can also specify options that can
# be used to single out a specific subset of boxes in a particular role, like
# :primary => true.

  
  
task :production do
  
  role :web, '65.74.174.196:8163' # freehub [mongrel] [mysql50-4-master,mysql50-staging-1]
  role :app, '65.74.174.196:8163', :mongrel => true
  role :db, '65.74.174.196:8163', :primary => true
  
  
  set :rails_env, 'production'
  set :environment_database, defer { production_database }
  set :environment_dbhost, defer { production_dbhost }
end

  
  
task :staging do
  
  role :web, '65.74.174.196:8164' # freehub [mongrel] [mysql50-4-master,mysql50-staging-1]
  role :app, '65.74.174.196:8164', :mongrel => true
  role :db, '65.74.174.196:8164', :primary => true
  
  
  set :rails_env, 'staging'
  set :environment_database, defer { staging_database }
  set :environment_dbhost, defer { staging_dbhost }
end

  
  
  
  
  
  
  
  
  
  
  
  
  
  


# =============================================================================
# Any custom after tasks can go here.
# after "deploy:symlink_configs", "freehub_custom"
# task :freehub_custom, :roles => :app, :except => {:no_release => true, :no_symlink => true} do
#   run <<-CMD
#   CMD
# end
# =============================================================================

# Don't change unless you know what you are doing!

after "deploy", "deploy:cleanup"
after "deploy:migrations", "deploy:cleanup"
after "deploy:update_code","deploy:symlink_configs"

# uncomment the following to have a database backup done before every migration
# before "deploy:migrate", "db:dump"

