# Balrog

![Balrog logo](https://user-images.githubusercontent.com/32128719/55335192-9566a000-5492-11e9-9449-746de68fbe94.png)

[![Gem Version](https://badge.fury.io/rb/balrog.svg)](https://badge.fury.io/rb/balrog)
[![CircleCI](https://circleci.com/gh/pixielabs/balrog.svg?style=svg)](https://circleci.com/gh/pixielabs/balrog)

Balrog is a lightweight authorization library for Ruby on Rails >= 5 written by
[Pixie Labs](https://pixielabs.io) that can protect your routes. Balrog can be 
configured to authorize users using a simple password or Single Sign-on or both.

- If you choose to protect your routes with a password, the password will be 
 stored as a password hash, not plain text, and Balrog provides a lightweight 
 HTML form that can be styled and used with password managers.
- If you choose to configure Balrog to use SSO, you can whitelist multiple email 
domains, allowing groups of users access parts of your app, without circulating
a password.
- Balrog's authentication can and should be configured to expire, requiring 
users to sign-in again in accordance with [OWASP](https://cheatsheetseries.owasp.org/cheatsheets/Session_Management_Cheat_Sheet.html#session-expiration) best practices.
- Balrog can also be used to restrict access to [mounted Rack applications](#Restricting-access-to-mounted-Rack-applications-within-config/routes.rb) like Sidekiq.

## Table of Contents

- [Installation](#Installation)
- [Regenerating a password hash](#Regenerating-a-password-hash)
- [Restricting access in a controller](#Restricting-access-in-a-controller)
- [Restricting access to mounted Rack applications](#Restricting-access-to-mounted-Rack-applications-within-config/routes.rb)
- [Logout button](#Logout-button)
- [Changing session expiry length](#Changing-session-expiry-length)
- [Configuring the Balrog gate view](#Configuring-the-Balrog-gate-view)
- [Single Sign On](#Single-Sign-On)
- [Upgrading from 1.1 to 2.0](#Upgrading-from-1.1-to-2.0)
- [Contributing](#Contributing)

## Installation

Add the gem to your Gemfile:

```ruby
gem 'balrog'
```

Run the installer to generate an initializer:

```shell
$ bundle exec rails generate balrog:install
Enter New Password: 
Confirm New Password: 
      create  config/initializers/balrog.rb
$
```

## Regenerating a password hash

If you need to create a new password, modify the hash in the Balrog initializer.
You can generate a new hash with the provided Rake task:

```
$ bundle exec rails balrog:generate_hash
New password: *******
Type again: *******

$2a$04$8U/Yun3MZ5..FuT9yUJNK.F2uUuHagtvsD.CNc5lSZegzq9eJjwqu

Copy this hash into config/initializers/balrog.rb
```

## Restricting access in a controller

```ruby
class AdminController < ApplicationController
  before_action :authenticate_with_balrog!
end
```

## Restricting access to mounted Rack applications within config/routes.rb

Use the `.use` [method](https://www.rubydoc.info/gems/rack/Rack%2FBuilder:use) to add Balrog to the 'stack'. 

For example with Sidekiq::Web...

```ruby
# Then we tell SideKiq to use Balrog::RoutesMiddleware
Sidekiq::Web.use Balrog::RoutesMiddleware

mount Sidekiq::Web => '/sidekiq'
```

N.B. If you are mounting Sidekiq Web, you need to [disable Sidekiq Web's session in config/initializers/sidekiq.rb](https://github.com/mperham/sidekiq/issues/3377#issuecomment-381254940).

```ruby
require 'sidekiq/web'

# In order to force sidekiq to use the rails app's session,
# we need to disable the Sidekiq's session.
Sidekiq::Web.disable(:sessions)
```

## Logout button

To add a logout button, you can call the `balrog_logout_button` view helper
method and pass in a hash of HTML options to style it. After logout, the user
will be redirected to the root of the app.

For example, in your view:

```erb
<ul class='nav'>
  <li>....</li>
  <li><%= balrog_logout_button 'Admin Logout' %></li>
  <li>....</li>
</ul>
```

Other usage examples:

```erb
<%= balrog_logout_button %>
<%= balrog_logout_button "Leave this place" %>
<%= balrog_logout_button "Click me", class: 'fancy-button--with-custom-text' %>
<%= balrog_logout_button class: 'fancy-button--with-default-text' %>
```

## Changing session expiry length

`set_session_expiry` requires the user to login again after a period of time.
To customise this value, open `config/initializers/balrog.rb` after running `balrog:install`
and change the argument being passed to `set_session_expiry`.

The argument passed to `set_session_expiry` can be any of the
[Rails time extensions](https://api.rubyonrails.org/classes/Numeric.html).

If you don't want sessions to expire, remove `set_session_expiry`
from the initializer completely.

```ruby
Balrog::Middleware.setup do |config|
  config.password_hash '$2a$12$BLz7XCFdG9YfwL64KlTgY.T3FY55aQk8SZEzHfpHfw15F2uN1kuSi'
  config.set_session_expiry 30.minutes
end
```

## Configuring the Balrog gate view

We built Balrog to have a default view and stylesheet so that you can drop 
Balrog into your project and everything should “just work”.
However, we don't want to be in your way if you needed to customise 
your Balrog gate view.

If you want to customise the Balrog view, you can run the `balrog:view` 
generator, which will copy the required view and layout to your application:

```shell
$ rails generate balrog:view
```

After running the generator, you can now add elements and classes to the 
`views/balrog/gate.html.erb`, add styles to the 
`assets/stylesheets/application.css` and import the application stylesheet in 
`app/views/layouts/balrog.html.erb`. For an example, see the 
[dummy-rails-app](https://github.com/pixielabs/balrog/tree/master/spec/dummy-rails-app) in the spec folder.

## Single Sign On

To add single sign on you will need to add the [omniauth gem](https://github.com/omniauth/omniauth)
to your gem file, along with the omniauth gem for your chosen
[provider](https://github.com/omniauth/omniauth/wiki/List-of-Strategies).

In `config/initializers/balrog.rb`, call `config.set_omniauth` in the setup block.
`.set_omniauth` takes the same arguments as the `OmniAuth::Builder#provider`
[method](https://github.com/omniauth/omniauth#getting-started),
a provider and any required keys.

To whitelist any email addresses with a specific domain, call
`config.set_domain_whitelist`in the setup block and pass in the domain.
If you want to whitelist multiple domains, you can pass multiple domains
to the `.set_domain_whitelist`.

Balrog does not require a password to be set if you wish to use single sign-on only. 

```ruby
Balrog::Middleware.setup do |config|
  credentials = Rails.application.credentials
  config.set_omniauth :google_oauth2, credentials.google_client_id, credentials.google_client_secret
  config.set_domain_whitelist 'pixielabs.io', 'the_fellowship.com'
end
```

## Upgrading from 1.1 to 2.0

To upgrade, you will need to change your balrog initializer. 

1. Instead of calling `Rails.application.config.middleware.use Balrog::Middleware`, you will now need to call `Balrog::Middleware.setup`. 

2. You will also need to change the block you pass into these methods as well. `#password_hash` and `#set_session_expiry` now need to called on a block parameter, e.g `set_session_expiry 30.minutes` needs to be changed to `config.set_session_expiry 30.minutes`.

See below for code examples.

```ruby
# Balrog 1.1
Rails.application.config.middleware.use Balrog::Middleware do
  password_hash '$2a$12$I8Fp3e2GfSdM7KFyoMx56.BVdHeeyk9DQWKkdsxw7USvU/mC8a8.q'
  set_session_expiry 30.minutes
end
```

```ruby
# Balrog 2.0
Balrog::Middleware.setup do |config|
  config.set_password_hash '$2a$12$9lquJW6mVYYS1pD1xYMGzulyC6sEDuLIUfkA/Y7F3RQ8psLNYyLeO'
  config.set_session_expiry 30.minutes
end
```

## Contributing

### Running the tests

Tests are part of the dummy Rails app within the spec folder:

```
$ cd spec/dummy-rails-app
$ bundle
$ rspec
```

Before contributing, please read the [code of conduct](CODE_OF_CONDUCT.md).
- Check out the latest master to make sure the feature hasn't been implemented
  or the bug hasn't been fixed yet.
- Check out the issue tracker to make sure someone already hasn't requested it
  and/or contributed it.
- Fork the project.
- Start a feature/bugfix branch.
- Commit and push until you are happy with your contribution.
- Please try not to mess with the package.json, version, or history. If you
  want to have your own version, or is otherwise necessary, that is fine, but
  please isolate to its own commit so we can cherry-pick around it.

## TODO

 * Restricting access via `routes.rb`
 * Test coverage
