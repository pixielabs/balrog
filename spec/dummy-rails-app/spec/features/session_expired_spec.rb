require 'rails_helper'

RSpec.describe "Session expires" do 
  include ActiveSupport::Testing::TimeHelpers

  context "as an authenticated user" do
    before(:each) do
      visit '/admin'
      fill_in 'password', with: 'password'
      click_button 'Login'
    end

    context "visiting the admin page" do
      it "shows the admin page" do
        visit '/admin'
        expect(page).to have_text "Let me in, I'm Admin#Index."
      end

      context "after waiting for the session to expire" do
        before do
          travel 5.hours
        end

        it "does not show the admin page" do
          visit '/admin'
          expect(page).to_not have_text "Let me in, I'm Admin#Index."
          expect(page).to have_field 'password'
        end

        after do
          travel_back
        end
      end
    end

    context "visiting the /sidekiq" do
      it "shows the sidekiq page" do
        visit '/sidekiq'
        expect(page).to have_text "Sidekiq"
      end

      context "after waiting for the session to expire" do
        before do
          travel 5.hours
        end
        
        it "does not show the sidekiq page" do
          visit '/sidekiq'
          expect(page).to_not have_text "Sidekiq"
          expect(page).to have_field 'password'
        end

        after do
          travel_back
        end
      end
    end
  end
end