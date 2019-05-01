require 'rails_helper'

RSpec.describe "Logging out of admin pages" do 
  before(:example) do
    visit '/admin'
    fill_in 'password', with: 'password'
    click_button 'Login'
  end

  it "redirects to the root" do
    click_button 'Logout'
    expect(current_path).to eq '/'
  end
  
  it "after logout, cannot access admin pages" do
    click_button 'Logout'
    visit '/admin'
    expect(page).to_not have_text "Let me in, I'm Admin#Index."
    expect(page).to have_field 'password'
  end
end