require 'spec_helper'
require_relative '../../../../lib/balrog/view_helpers'

RSpec.describe Balrog::ViewHelpers, type: :helper do
  include Balrog::ViewHelpers

  describe 'balrog_logout_button' do
    it "can be called without any arguments" do
      html = balrog_logout_button
      expected_response_string = '<form class="button_to" method="post" action="/balrog/logout">'\
        '<input type="hidden" name="_method" value="delete" />'\
        '<input type="submit" value="Logout" /></form>'
      expect(html).to eq expected_response_string
    end
    it "can be called with a string" do
      html = balrog_logout_button 'Leave this location'
      expected_response_string = '<form class="button_to" method="post" action="/balrog/logout">'\
        '<input type="hidden" name="_method" value="delete" />'\
        '<input type="submit" value="Leave this location" /></form>'
      expect(html).to eq expected_response_string
    end
    it "can be called with a key-value pair" do
      html = balrog_logout_button class: 'big-red-button'
      expected_response_string = '<form class="button_to" method="post" action="/balrog/logout">'\
        '<input type="hidden" name="_method" value="delete" />'\
        '<input class="big-red-button" type="submit" value="Logout" /></form>'
      expect(html).to eq expected_response_string
    end
    it "can be called with multiple key-value pairs" do
      html = balrog_logout_button class: 'big-red-button', id: 'panic-button'
      expected_response_string = '<form class="button_to" method="post" action="/balrog/logout">'\
        '<input type="hidden" name="_method" value="delete" />'\
        '<input class="big-red-button" id="panic-button" type="submit" value="Logout" /></form>'
      expect(html).to eq expected_response_string
    end
    it "can be called with a string and a key-value pair" do
      html = balrog_logout_button 'Leave this location', id: 'panic-button'
      expected_response_string = '<form class="button_to" method="post" action="/balrog/logout">'\
        '<input type="hidden" name="_method" value="delete" />'\
        '<input id="panic-button" type="submit" value="Leave this location" /></form>'
      expect(html).to eq expected_response_string
    end
  end
end