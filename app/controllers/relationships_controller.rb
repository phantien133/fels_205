class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def create
    @user = User.find_by id: params[:followed_id]
    return user_not_found unless @user
    current_user.follow @user
    @relationship = current_user.active_relationships.find_by(followed_id: @user.id)
    respond
  end

  def destroy
    @user = Relationship.find_by(id: params[:id]).followed
    return user_not_found unless @user
    current_user.unfollow @user
    @relationship = current_user.active_relationships.build
    respond
  end

  private
  def user_not_found
    flash[:danger] = t :user_not_found
    redirect_to users_path and return
  end

  def respond
    respond_to do |format|
      format.html {redirect_to @user}
      format.js
    end
  end
end
