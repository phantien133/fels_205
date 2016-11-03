class LessonsController < ApplicationController
  before_action :logged_in_user, except: [:show, :index]
  before_action :verify_admin, except: [:show, :index]
  before_action :load_lesson, only: [:edit, :update, :destroy]

  def new
    store_location
    @lesson = Lesson.new
  end

  def create
    @lesson = current_user.lessons.build lesson_params
    if @lesson.save
      flash[:success] = t :created_at
    else
      flash[:danger] = @lesson.errors.full_messagesjoin "\n"
    end
    redirect_to session[:forwarding_url] || new_lesson_path
  end

  def destroy
    respond_to do |format|
      format.json do
        if @lesson.destroy
          render json: {status: t(:deleted)}
        else
          render json: {status: t(:delete_failed)}
        end
      end
    end
  end

  def index
    if params[:category_id].present?
      @lessons = Lesson.of_category(params[:category_id])
        .search(params[:key])
        .paginate page: params[:page],
        per_page: Settings.per_page
    else
      @lessons = Lesson.search(params[:key])
        .paginate page: params[:page],
        per_page: Settings.per_page
    end
    @lessons.includes(:category)
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
end
