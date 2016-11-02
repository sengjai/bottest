class CreateQuestionAnswers < ActiveRecord::Migration
  def change
    create_table :question_answers do |t|
      t.belongs_to :bot, index: true
      t.text :user_says
      t.text :bot_answers
      t.text :bot_answers_2
      t.string :keywords

      t.timestamps null: false
    end
  end
end
