# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_webtrends_session',
  :secret      => '438a9db93847bc830bef0cb54e76ff6821969504f78ca8ff26f072892c30bffb3dcda2718611467acbfe15ca333a40d5f9064534c7c415b060dc4c707c08cf68'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
