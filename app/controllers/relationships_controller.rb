class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def create
    @user = User.find params[:followed_id]
    verify_user
    current_user.follow @user
    respond
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    verify_user
    current_user.unfollow @user
    respond
  end

  private
  def verify_user
    unless @user
      flash[:danger] = t "not_found"
      redirect_to users_path
    end
  end

  def respond
    respond_to do |format|
      format.html {redirect_to @user}
      format.js
    end
  end
end
