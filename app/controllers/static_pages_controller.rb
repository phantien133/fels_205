class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @user = current_user
      @activities = Activity.users_activities(current_user.id)
        .paginate page: params[:page], per_page: Settings.per_page
    end
    store_location
  end
end
