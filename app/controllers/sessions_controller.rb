class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user && user.authenticate(params[:session][:password])
      flash[:success] = t :wellcome_back, name: user.name
      log_in user
      remember user
    else
      flash[:danger] = t :login_fail
    end
    redirect_to session[:forwarding_url] || root_url
  end

  def destroy
    flash[:info] = t :goodbye, name: current_user.name
    log_out
    redirect_to root_path
  end
end
