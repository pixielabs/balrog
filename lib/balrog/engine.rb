class Balrog::Engine < Rails::Engine
  # Make authenticate_with_balrog! available.
  initializer "balrog.action_controller" do 
    ActiveSupport.on_load(:action_controller) do
      require_relative 'helpers'
      include Balrog::Helpers
    end
  end

  # Add balrog_logout_button as a global view helper.
  initializer "balrog.action_view" do
    ActiveSupport.on_load(:action_view) do
      require_relative 'view_helpers'
      include Balrog::ViewHelpers
    end
  end

  # Precompile the Balrog assets
  initializer "balrog.assets.precompile" do |app|
    app.config.assets.precompile += %w( 
      balrog/gate.css
      balrog/logo.png
    )
  end
end
