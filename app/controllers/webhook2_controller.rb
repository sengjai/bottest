class Webhook2Controller < ApplicationController

	 skip_before_action :verify_authenticity_token

	def webhook	
		if params['hub.verify_token'] == 'mytoken2'
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
	        send_text_message(sender, "Hi there! You said: #{text}. The Bots WONDER from test2")
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
	   "https://graph.facebook.com/v2.6/me/messages?access_token=EAAEoc0M82B4BAGYlXWKGotKLzdi6ohygsob8qk2kQiSsCtyd3PWuqyfrDum3HtLfH7nPd11bMcdvSdYhzpJKiHNALD3oBd7hjAygKYs1r0xvEM36WwzhMhHcTY4ZCsACGhZClXjiXsDvzZAyscB3XDy3WMxHmIzBDETHzeiMwZDZD",
	   body: body,
	   headers: { 'Content-Type' => 'application/json' }
	  )
	end






end
