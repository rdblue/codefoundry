# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key    => '_codefoundry_session',
  :secret => 'c36afd6cdc0ff826c8b672e15892c95fea6239aa7d1247e69d1292bcb7464d4688f14d6320242a7000231040d69b5cc70b45b52d42e36b3ab884579c54997df9'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
