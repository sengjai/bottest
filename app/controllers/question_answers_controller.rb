class QuestionAnswersController < ApplicationController
  before_action :which_bot, only: [:index, :create, :new, :update, :destroy]
  before_action :all_question_answers, only: [:index, :create, :update, :destroy]
  before_action :set_question_answer, only: [:edit, :update, :destroy]
  respond_to :html, :js
  
  def new
    @question_answer=@bot.question_answers.new
  end

  def create

    @question_answer=@bot.question_answers.create(entry_params)
    @block_created=@bot.question_answers.last
  end

  

  def index
   
  end

  def edit
  end

  def update
    @question_answer.update_attributes(entry_params)
  end

  def destroy
    @question_answer.destroy
  end


  private
  def which_bot
    @bot=Bot.find(params[:bot_id])
    return @bot
  end

  def set_question_answer
    @question_answer=QuestionAnswer.find(params[:id])
  end

  def all_question_answers
 
    
    @blocks=@bot.question_answers.all
  end

  def entry_params
    params.require(:question_answer).permit(:user_says, :bot_answers, :bot_answers_2, :keywords)
  end
end

 # create_table "question_answers", force: :cascade do |t|
 #    t.integer  "bot_id"
 #    t.text     "user_says"
 #    t.text     "bot_answers"
 #    t.text     "bot_answers_2"
 #    t.string   "keywords"
 #    t.datetime "created_at",    null: false
 #    t.datetime "updated_at",    null: false
 #  end