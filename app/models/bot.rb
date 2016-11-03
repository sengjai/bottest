class Bot < ActiveRecord::Base
	belongs_to :user
	has_many :question_answers
	has_many :bot_users

	validates :uri, uniqueness: true
	validates :token, presence: true
end
