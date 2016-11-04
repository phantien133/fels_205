class FollowersController < ApplicationController
  before_action :logged_in_user
  before_action :find_user, only: :index

  def index
    @users = @user.followers.search(params[:key]).paginate page: params[:page],
      per_page: Settings.per_page
  end
end
