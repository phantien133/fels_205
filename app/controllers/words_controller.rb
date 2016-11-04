class WordsController < ApplicationController
  before_action :logged_in_user, only: [:destroy, :edit, :update]
  before_action :verify_admin, only: [:destroy]
  before_action :load_word, only: [:edit, :update]

  def new
    @word = Word.new
  end

  def edit

  end

  def update
    if @word.update_attributes(answers_params)
      flash[:success] = t :updated
      redirect_to session[:forwarding_url] || words_path
    else
      flash[:warning] = @word.errors.full_messages.join ".\n"
      redirect_to edit_word_path(@words)
    end
  end

  def create
    @word = Word.new word_params
    if @word.save &&  @word.update_attributes(answers_params)
      flash[:success] = t :created_at
      redirect_to session[:forwarding_url] || new_word_path and return
    else
      flash[:warning] = @word.errors.full_messages.join ".\n"
      redirect_to new_word_path
    end
  end

  def index
    @words = if params[:category_id]
      Word.of_category(params[:category_id])
        .search_by_content(params[:key])
    else
      Word.search_by_content(params[:key])
    end.paginate page: params[:page],per_page: Settings.per_page
  end

  private
  def word_params
    params.require(:word)
      .permit :content,:category_id
  end

  def answers_params
    params.require(:word)
      .permit answers_attributes: [:content, :correct]
  end

  def load_word
    @word = Word.find_by id: params[:id]
    unless @word
      flash[:danger] = t :word_not_found
      redirect_to words_path
    end
  end
end
