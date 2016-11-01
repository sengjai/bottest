class BotController < ApplicationController
def webhook
		if params['hub.verify_token'] == 'mytoken'
			render text: params['hub.challenge'] and return
		else
			render text: params['hub.challenge'] and return
		end
	end
end