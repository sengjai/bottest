class BotController < ApplicationController
	def webhook	
		if params['hub.verify_token'] == 'mytoken'
			render text: params['hub.challenge'] and return
		else
			render text: 'error' and return
		end
	end

	def receive_message

		render text: 'hello' and return
	end	
end

