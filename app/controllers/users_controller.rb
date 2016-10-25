class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:info] = t :wellcome, name: @user.name
      redirect_to root_url
    else
      render :new
    end
  end

  def show
    @user = User.find_by id: params[:id]
    if @user.nil?
      flash[:info] = t :user_not_found
      redirect_to root_url
    end
  end

  private
    def user_params
      params.require(:user).permit :name,
        :birthday, :email, :sex, :address,
        :phone, :password,
        :password_confirmation, :avatar
    end

end
