class ChangeColumnKeywordsInQuestionAnswers < ActiveRecord::Migration
  def change
  add_column :question_answers, :mainkeywords, :string, array: true, default:[]
  end
end
