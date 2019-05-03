# Balrog

![Balrog logo](https://user-images.githubusercontent.com/32128719/55335192-9566a000-5492-11e9-9449-746de68fbe94.png)

[![CircleCI](https://circleci.com/gh/pixielabs/balrog.svg?style=svg)](https://circleci.com/gh/pixielabs/balrog)

Balrog is a lightweight authorization library for Ruby on Rails written by
[Pixie Labs](https://pixielabs.io) that can protect your routes with a single
username & password combination.

Balrog is an alternative to `http_basic_authentication_with` that provides some
advantages:

* Uses a password hash instead of a plaintext password.
* Provides a lightweight HTML form instead of inconsistent basic
  authentication.
* Better support for password managers (which often don't support basic
  authentication dialog boxes).

## Requirements

Balrog is designed to be used with Ruby on Rails applications, and has been
tested against Ruby on Rails 5.

## Installation

Add the gem to your Gemfile:

```ruby
gem 'balrog'
```

Run the installer to generate an initializer:

```
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
 * Check it's OK with Ruby on Rails 6
 * Expire sessions
