class QuestionAnswer < ActiveRecord::Base
	belongs_to :bot

	# scope :keywords_contain, ->(word) { where('ARRAY["?"] @> keywords', word) }

end
