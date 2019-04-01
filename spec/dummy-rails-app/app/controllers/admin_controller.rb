class AdminController < ApplicationController
  before_action :authenticate_with_balrog! 

  def index; end

end
