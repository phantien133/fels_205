class UsersController < ApplicationController
  before_action :logged_in_user, only: [:destroy, :edit, :update]
  before_action :load_user, except: [:new, :create, :index]
  before_action :correct_user, only: [:edit, :update]
  before_action :verify_admin, only: [:destroy]

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:info] = t :wellcome, name: @user.name
      log_in @user
      redirect_to root_url
    else
      render :new
    end
  end

  def show
    store_location
    @activities = @user.activities.paginate page: params[:page],
      per_page: Settings.per_page
    if logged_in?
      @relationship = current_user.active_relationships.find_by(followed_id: @user.id)
      if @relationship.blank? || @relationship.nil?
         @relationship = current_user.active_relationships.build
      end
    end
    Lesson.unscoped @activities
  end

  def edit
  end

  def update
    if @user.update_attributes user_params
      flash[:success] = t :updated
      redirect_to root_url
    else
      render :edit
    end
  end

  def index
    @users = User.search(params[:key]).paginate page: params[:page],
      per_page: Settings.per_page
  end

  def destroy
    unless @user.destroy
      flash[:warning] = t :failed, name: @user.name
      redirect_to users
    end
  end

  private
  def user_params
    params.require(:user).permit :name,
      :birthday, :email, :sex, :address,
      :phone, :password,
      :password_confirmation, :avatar
  end

  def correct_user
    unless current_user.is_user? @user
      flash[:danger] = t :user_not_correct
      redirect_to root_url
    end
  end

  def load_user
    @user = User.find_by id: params[:id]
    unless @user
      flash[:danger] = t :user_not_found
      redirect_to root_url
    end
  end
end
