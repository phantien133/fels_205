class WordsController < ApplicationController
  before_action :logged_in_user, only: [:destroy, :edit, :update]
  before_action :verify_admin, except: [:index, :show]
  before_action :load_word, only: [:edit, :update, :destroy]
  before_action :load_all_categories, only: [:index, :new, :edit]

  def index
    store_location
    @words = if params[:condition].present? &&
      params[:condition]  != t("get_all") && logged_in?
      Word.unscoped.send(params[:condition], current_user.id)
    else
      Word.all
    end.of_category(params[:category_id]).search_by_content(params[:key])
      .includes(:answers).paginate page: params[:page],
      per_page: Settings.per_page
    @word = Word.new if logged_in? && current_user.admin?
  end

  def new
    @word = Word.new
  end

  def create
    @word = Word.new word_params
    if @word.save &&
      if @word.update_attributes(answers_params)
        flash[:success] = t :created_at
        redirect_to session[:forwarding_url] || new_word_path and return
      else
        @word.destroy
      end
    end
    flash[:warning] = @word.errors.full_messages.join ".<br>"
    redirect_to new_word_path
  end

  def edit
  end

  def update
    if @word.update_attributes word_answers_params
      flash[:success] = t :updated
      redirect_to session[:forwarding_url] || words_path
    else
      flash[:warning] = @word.errors.full_messages.join ".<br>"
      redirect_to edit_word_path @word
    end
  end

  def destroy
    respond_to do |format|
      format.json do
        if @word.destroy
          render json: {status: t(:deleted)}
        else
          render json: {status: t(:delete_failed)}
        end
      end
    end
  end

  private
  def word_answers_params
    params.require(:word) .permit :content,:category_id,
      answers_attributes: [:id, :content, :correct, :_destroy]
  end

  def word_params
    params.require(:word)
      .permit :content,:category_id
  end

  def answers_params
    params.require(:word)
      .permit answers_attributes: [:id, :content, :correct]
  end

  def load_word
    @word = Word.find_by id: params[:id]
    unless @word
      flash[:danger] = t :word_not_found
      redirect_to words_path
    end
  end

  def load_all_categories
    @all_categories = Category.all
  end
end
