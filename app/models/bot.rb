class Bot < ActiveRecord::Base
	belongs_to :user
	has_many :question_answers
	has_many :bot_users
end
