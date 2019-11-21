require 'rails_helper'

RSpec.describe "Viewing admin pages" do 
  context "as an unauthenticated user" do
    it "redirects to Balrog Gate" do
      visit '/admin'
      expect(page).to_not have_text "Let me in, I'm Admin#Index."
      expect(page).to have_field 'password'
    end
    describe "with the right password" do
      it "shows the admin page" do
        visit '/admin'
        fill_in 'password', with: 'password'
        click_button 'Login'
        expect(page).to have_text "Let me in, I'm Admin#Index."
      end
    end
    describe "with the wrong password" do
      it "shows the Balrog Gate page" do
        visit '/admin'
        fill_in 'password', with: 'wrong_password'
        click_button 'Login'
        expect(page).to_not have_text "Let me in, I'm Admin#Index."
        expect(page).to have_field 'password'
      end
    end
    context "using single sign on" do
      it "shows the admin page" do
        visit '/admin'
        click_link 'Sign in with SSO'
        expect(page).to have_text "Let me in, I'm Admin#Index."
      end
      describe "with the wrong email" do
        it "shows the Balrog Gate page" do
          OmniAuth.config.add_mock(
            :google_oauth2,
            info: { email: "samwise@shire-landscaping.org" }
          )
          visit '/admin'
          click_link 'Sign in with SSO'
          expect(page).to_not have_text "Let me in, I'm Admin#Index."
          expect(page).to have_field 'password'
        end
      end
    end
  end
end