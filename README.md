# Balrog

![Balrog logo](https://user-images.githubusercontent.com/32128719/55335192-9566a000-5492-11e9-9449-746de68fbe94.png)

[![Gem Version](https://badge.fury.io/rb/balrog.svg)](https://badge.fury.io/rb/balrog)
[![CircleCI](https://circleci.com/gh/pixielabs/balrog.svg?style=svg)](https://circleci.com/gh/pixielabs/balrog)

Balrog is a lightweight authorization library for Ruby on Rails >= 5 written by
[Pixie Labs](https://pixielabs.io) that can protect your routes with a single
username & password combination.

Balrog is an alternative to `http_basic_authentication_with` that provides some
advantages:

* Uses a password hash instead of a plaintext password.
* Provides a lightweight HTML form instead of inconsistent basic
  authentication.
* Better support for password managers (which often don't support basic
  authentication dialog boxes).

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
Configuring this with Balrog is easy. Just go the initializer in your config file,
and change the argument being passed to `set_session_expiry`.

The argument passed to `set_session_expiry` can be any of the
[Rails time extensions](https://api.rubyonrails.org/classes/Numeric.html).

If you don't want your session to expire, you can remove `set_session_expiry`
from the initializer completely.

```ruby
Rails.application.config.middleware.use Balrog::Middleware do
  password_hash '$2a$12$BLz7XCFdG9YfwL64KlTgY.T3FY55aQk8SZEzHfpHfw15F2uN1kuSi'
  set_session_expiry 30.minutes
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
 * Expire sessions
