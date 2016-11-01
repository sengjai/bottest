class BotController < ApplicationController
	 skip_before_action :verify_authenticity_token

	def webhook	
		if params['hub.verify_token'] == 'mytoken'
			render text: params['hub.challenge'] and return
		else
			render text: 'error' and return
		end
	end

	 def receive_message

	 render text: params['messaging'] and return
	 end	
end

