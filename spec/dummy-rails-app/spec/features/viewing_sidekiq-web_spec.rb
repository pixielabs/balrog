require 'rails_helper'

RSpec.describe "Viewing Sidekiq" do 
  context "as an unauthenticated user" do
    it "redirects to Balrog Gate" do
      visit '/sidekiq'
      expect(page).to_not have_text "Sidekiq"
      expect(page).to have_field 'password'
    end
    describe "with the right password" do
      it "shows the admin page" do
        visit '/sidekiq'
        fill_in 'password', with: 'password'
        click_button 'Login'
        expect(page).to have_text "Sidekiq"
      end
    end
    describe "with the wrong password" do
      it "shows the Balrog Gate page" do
        visit '/sidekiq'
        fill_in 'password', with: 'wrong_password'
        click_button 'Login'
        expect(page).to_not have_text "Sidekiq"
        expect(page).to have_field 'password'
      end
    end
  end
  context "as an authenticated user" do
    before(:example) do
      visit '/admin'
      fill_in 'password', with: 'password'
      click_button 'Login'
    end
    it "shows Sidekiq web" do
      visit '/sidekiq'
      expect(page).to have_text "Sidekiq"
    end
    describe "after logging out" do
      it "shows the Balrog Gate page" do
        click_button 'Logout'
        visit '/sidekiq'
        expect(page).to_not have_text "Sidekiq"
        expect(page).to have_field 'password'
      end
    end
  end
end