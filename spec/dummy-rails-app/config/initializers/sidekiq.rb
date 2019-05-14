require 'sidekiq/web'

# In order to force sidekiq to use the rails app's session,
# we need to disable the Sidekiq's session.
Sidekiq::Web.disable(:sessions)
