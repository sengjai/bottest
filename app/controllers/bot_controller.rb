class BotController < ApplicationController
	before_action :require_login, only: [:start, :create]
	skip_before_action :verify_authenticity_token

	
	def start
		@webhook_uri=SecureRandom.hex(6)
		@secret=SecureRandom.hex(4)
	end

	def create
		@bot=current_user.bots.new(bot_params)
	  	if @bot.save
	  		redirect_to start2_path
	  	end
  	end

  	def start2
  		bot=current_user.bots.last
		@webhook_uri = bot.uri
		@secret	=bot.secret
	end

  	def show
  		bot = Bot.find_by(uri: params[:uri])
  		saved_secret=bot.secret
  		@token=bot.token

		if params['hub.verify_token'] == saved_secret
			render text: params['hub.challenge'] and return
		else
			render text: 'error' and return
		end
  	end


	#-----
	# def webhook	
	# 	if params['hub.verify_token'] == 'mytoken33'
	# 		render text: params['hub.challenge'] and return
	# 	else
	# 		render text: 'error' and return
	# 	end
	# end
		
	#Receive Message from Customer	
	def receive_message
	 if params[:entry]
	   messaging_events = params[:entry][0][:messaging]
     messaging_events.each do |event|
     sender = event[:sender][:id]
     	if event[:message] != nil
     		send_text_message(sender, "Normal received message")
     	elsif event[:postback] != nil
     		#Do a case statement here
     		if event[:postback][:payload] == "test"
     			send_post_message(sender, "Postback Message received, Yes")
     		elsif event[:postback][:payload] == "EXTERMINATE"
     			send_post_message(sender, "Postback Message received, No")
     		end
     	end
     
   	 end
	 end
	 render nothing: true
	end

	#Replying Message from Buttons Postback
	def send_post_message(sender, text)
		  		bot = Bot.find_by(uri: params[:uri])
  		
  		@token=bot.token
		body = {
		   recipient: {
		     id: sender
		   },

		   message: {
		     text: text
		   }
		  }.to_json
		  
		  response = HTTParty.post(
		   "https://graph.facebook.com/v2.6/me/messages?access_token=#{@token}",
		   body: body,
		   headers: { 'Content-Type' => 'application/json' }
		  )
		end	

	#Sending Message Via buttons or Web URL
	def send_text_message(sender, text)
		bot = Bot.find_by(uri: params[:uri])
  		@token=bot.token
		
	  body = {
	   recipient: {
	     id: sender
	   },

	   message: {
	     attachment: {
		      type: 'template',
		      payload: {
		        template_type: 'button',
		        text: "Hello, you feeling good?",
		        buttons: [
		          { type: 'web_url', 
		          	url: 'http://www.google.com',
		          	title: 'View Website' },
		          { type: 'postback', title: 'No', payload: 'EXTERMINATE' },
		          { type: 'postback', title: 'Yes', payload: 'test' }
		        ]
		      }
		    }
	   }
	  }.to_json
	  
	  response = HTTParty.post(
	   "https://graph.facebook.com/v2.6/me/messages?access_token=#{@token}",
	   body: body,
	   headers: { 'Content-Type' => 'application/json' }
	  )
	end

  private


	def bot_params
	   params.require(:bot).permit(:name, :token, :uri, :secret)
	end
end