class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  def logged_in_user
    unless logged_in?
      flash[:danger] = t :please_login
      redirect_to root_path
    end
  end

  def verify_admin
    unless current_user.admin?
      flash[:danger] = t :access_denied
      redirect_to root_path
    end
  end

  def find_user
    @user = User.find_by id: params[:user_id]
    unless @user
      flash[:danger] = t :user_not_found
      redirect_to root_url
    end
  end
end
