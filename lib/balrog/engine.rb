require_relative 'helpers'

class Balrog::Engine < Rails::Engine
  # Make the Balrog helpers available in any controller.
  initializer "balrog.configure_rails_initialization" do 
    ActiveSupport.on_load(:action_controller) do
      include Balrog::Helpers
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
