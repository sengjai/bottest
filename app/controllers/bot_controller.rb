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
	 if params[:entry]

	   messaging_events = params[:entry][0][:messaging]
	     messaging_events.each do |event|
	     sender = event[:sender][:id]
	     if (text = event[:message] && event[:message][:text])
	        send_text_message(sender, "Hi there #{sender}! You said: #{text}. The Bots")
	     end
	   end
	 end

	 render nothing: true
	end	


	def send_text_message(sender, text)
	  body = {
	   recipient: {
	     id: sender
	   },
	   message: {
	     text: text
	   }
	  }.to_json
	  
	  response = HTTParty.post(
	   "https://graph.facebook.com/v2.6/me/messages?access_token=EAAFEug8ZAQxQBANqZBO9Nq9WwN9v6nGeIUVhhMutCZBgQdeTNmDRFuZCYuAZCkRP7o9QwZC5AGJddFEiOHVbFTuW7TRbZACqbYUkaBjnLrPSRhAmLUEK2WZBezQxIjk1gNdndcQedJ4UZCNkyZBzqyRNGqiXs8GYUGfEHygc5egIthjwZDZD",
	   body: body,
	   headers: { 'Content-Type' => 'application/json' }
	  )
	end

end


