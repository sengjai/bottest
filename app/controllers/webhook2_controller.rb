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
	    name= get_profile_info(sender)
	    	   
	  ### HOW TO CONVERT NAME TO the first name only???? NEED TO PARSE data
	     if (text = event[:message] && event[:message][:text])
	      send_text_message(sender, "Hi #{name}! You said: #{text}. The Bots WONDER from test2")
	     end
	   end
	 end

	 render nothing: true
	end	

	def get_profile_info(sender)
	
	user_id = sender
	

	response = HTTParty.get(
	  "https://graph.facebook.com/v2.6/"+user_id+"?fields=first_name&access_token=EAAEoc0M82B4BAGYlXWKGotKLzdi6ohygsob8qk2kQiSsCtyd3PWuqyfrDum3HtLfH7nPd11bMcdvSdYhzpJKiHNALD3oBd7hjAygKYs1r0xvEM36WwzhMhHcTY4ZCsACGhZClXjiXsDvzZAyscB3XDy3WMxHmIzBDETHzeiMwZDZD" )
	
	body=JSON.parse(response.body)
	name=body["first_name"]
	
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
