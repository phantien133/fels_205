class CategoriesController < ApplicationController
  before_action :logged_in_user, except: [:index, :show]
  before_action :verify_admin, except: [:index, :show]
  before_action :get_category, except: [:new, :index, :create]

  def index
    store_location
    @category = Category.new
    if params[:key] && params[:commit].nil?
      @categories = Category.search(params[:key]).includes(:lessons).paginate page: params[:page],
        per_page: Settings.per_page
      @data = {categories: @categories, admin: current_user.admin,
        total_entries: @categories.total_entries,
        current: @categories.current_page,
        per_page: @categories.per_page}
      respond_to do |format|
        format.json do
          render json: @data
        end
      end
    else
      @categories = Category.search(params[:key]).paginate page: params[:page],
        per_page: Settings.per_page
    end
  end

  def destroy
    respond_to do |format|
      format.json do
        if @category.destroy
          render json: {status: t(:deleted)}
        else
          render json: {status: t(:delete_failed)}
        end
      end
    end
  end

  def create
    @category = Category.new category_params
    if @category.save
      flash[:success] = t :created_category, name: @category.name
      redirect_to categories_path
    else
      render :index
    end
  end

  def edit
  end

  def update
    if @category.update_attributes category_params
      flash[:success] = t :updated
      redirect_to categories_path
    else
      flash[:warning] = t :not_update
    end
    render :edit
  end

  def show
    store_location
    @word = @category.words.build
    @lessons = @category.lessons.paginate page: params[:page],
      per_page: Settings.per_page
    @lesson = @category.lessons.build
    @number_max_of_words = @category.words.size
  end

  private
    def get_category
      @category = Category.find_by id: params[:id]
      unless @category
        flash[:danger] = t :category_not_found
        redirect_to categories_path
      end
    end

    def category_params
      params.require(:category).permit :name
    end
end
