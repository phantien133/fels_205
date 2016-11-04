class LessonsController < ApplicationController
  before_action :logged_in_user, except: [:show, :index]
  before_action :verify_admin, except: [:show, :index]
  before_action :load_lesson, except: [:index, :new, :create]

  def index
    store_location
    @lessons = if params[:condition].present? &&
      params[:condition] != t("get_all") && logged_in?
    Lesson.send(params[:condition], current_user.id)
    else
      Lesson.all
    end.of_category(params[:category_id] || "").search(params[:key])
      .includes(:category).paginate page: params[:page],
      per_page: Settings.per_page
    @lesson = current_user.lessons.build if logged_in? && current_user.admin?
  end

  def new
    store_location
    @lesson = Lesson.new
  end

  def show
  end

  def edit
  end

  def update
    if @lesson.update_attributes lesson_params
      flash[:success] = t :updated
    else
      flash[:danger] = @lesson.errors.full_messages.join ".<br>"
    end
    redirect_to session[:forwarding_url] || new_lesson_path
  end

  def create
    @lesson = current_user.lessons.build lesson_params
    if @lesson.save
      flash[:success] = t :created_at
    else
      flash[:danger] = @lesson.errors.full_messages.join ".<br>"
    end
    redirect_to session[:forwarding_url] || new_lesson_path
  end

  def destroy
    respond_to do |format|
      format.json do
        if @lesson.delete
          render json: {status: t(:deleted)}
        else
          render json: {status: t(:delete_failed)}
        end
      end
    end
  end
  def destroy
    @id = params[:id]
    if params[:confirm]
      delete_lesson
    elsif @lesson.is_tested
      @status = t :lesson_have_tested
    else
      @status = t :confirm_delete,type: @lesson.id, name: @lesson.name
    end
  end

  private
  def lesson_params
    params.require(:lesson).permit :time,
      :category_id, :number_of_words, :name
  end

  def load_lesson
    @lesson = Lesson.find_by id: params[:id]
    unless @lesson
      flash[:danger] = t :lesson_not_found
      redirect_to lessons_path
    end
  end

  def delete_lesson
    respond_to do |format|
      format.json do
        if @lesson.delete
          render json: {status: t(:deleted)}
        else
          render json: {status: t(:delete_failed)}
        end
      end
    end
  end
end
