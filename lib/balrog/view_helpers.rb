# ViewHelpers methods are made available in all controllers by the code in engine.rb.
module Balrog::ViewHelpers
  def balrog_logout_button(html_options = {})
    html_options[:method] = 'delete'
    text = html_options.delete(:text) || 'Logout'
    button_to(text, '/balrog/logout', html_options)
  end
end
