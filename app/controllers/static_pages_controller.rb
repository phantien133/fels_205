class StaticPagesController < ApplicationController
  def home
    @user = current_user
    store_location
  end
end
