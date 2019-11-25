# ViewHelpers methods are made available in all views by the code in engine.rb.
module Balrog::ViewHelpers
  def balrog_logout_button(options = nil, html_options = nil)
    name = 'Logout'
    html_options ||= {}
    html_options[:method] = 'delete'

    if options.is_a?(String)
      name = options
    elsif options.is_a?(Hash)
      html_options = html_options.merge(options)
    end 

    button_to(name, '/balrog/logout', html_options)
  end

  def show_balrog_password_prompt?
    !!Balrog::Middleware.password_hash || !Balrog::Middleware.omniauth_config
  end

  def balrog_omniauth_configured?
    !!Balrog::Middleware.omniauth_config
  end
end
