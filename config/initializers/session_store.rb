# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_freehub_for_all_session',
  :secret      => '0997aa534656a97a788eb5ade4d382bbbeef876589d38649644a34c8c826c690ce7e218163569bb149b5d36772bafeb7f51aedd37201e6e96455fd6139737dbd'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
