class ResultsController < ApplicationController
  before_action :logged_in_user
  before_action :load_lesson, only: [:edit, :update, :show]
  before_action :load_result, only: [:edit, :update, :show]
  before_action :check_lesson, only: [:create]
  before_action :get_time_remaining, only: [:edit, :update]

  def create
    @result = Result.find_by lesson_id: @lesson.id, user_id: current_user.id
    if @result.nil?
      @result = current_user.results.build lesson_id: @lesson.id
      unless @result.save
        flash[:danger] = @result.errors.full_messages.join ".\n"
        redirect_to session[:forwarding_url] || lessons_path
      end
    end
    redirect_to edit_lesson_result_path @lesson, @result
  end

  def edit
    if @result.finished
      redirect_to lesson_result_path @lesson, @result
    end
    @choices = @result.choices.includes word: :answers
  end

  def update
    finished = params[:commit] == t(:finish) || params[:auto_commit] == Settings.finish_submit
    @result.finished = true if finished
    if @result.update_attributes result_params
      if finished
        flash[:success] = t ".finish_test"
        redirect_to lesson_result_path @lesson, @result
        return
      end
      @status = true
    else
      render :edit if finished
      @status = false
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
  end

  private
  def load_lesson
    @lesson = Lesson.unscoped.find_by id: params[:lesson_id]
    unless @lesson
      flash[:danger] = t :lesson_not_found
      redirect_to lessons_path
    end
  end

  def load_result
    @result = Result.find_by(id: params[:id])
    unless @result
      flash[:danger] = t :words_have_lost
      redirect_to lessons_path and return
    end
  end

  def check_lesson
    load_lesson
    unless @lesson.check_number_of_word?
      flash[:danger] = t :words_have_lost
      redirect_to lessons_path and return
    end
  end

  def result_params
    params.require(:result)
      .permit choices_attributes: [:id, :answer_id]
  end

  def get_time_remaining
    @time_remaining = @lesson.time - (Time.now - @result.created_at) / 60
    if @time_remaining < Settings.time_laster_for_submit && !@result.finished
      @result.update_attributes finished: true
      redirect_to lesson_result_path @lesson, @result
    end
  end
end
