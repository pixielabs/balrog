OmniAuth.config.test_mode = true

RSpec.configure do |config|

  config.before(:each) do
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
      provider: 'google_oauth2',
      info: {
        email: 'gandalf@pixielabs.io'
      }
    })
  end

  config.after(:each) do
    OmniAuth.config.mock_auth[:google_oauth2] = nil
  end
end