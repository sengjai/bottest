class BotController < ApplicationController
	before_action :require_login, only: [ :start, :create ]
	skip_before_action :verify_authenticity_token

	def start
		@webhook_uri = SecureRandom.hex(6)
		@secret = SecureRandom.hex(4)
	end

	def create
		@bot = current_user.bots.new(bot_params)
  	if @bot.save
  		redirect_to start2_path
  	end
	end

  def start2
  	@bot = current_user.bots.last
		@webhook_uri = @bot.uri
		@secret	= @bot.secret
	end

  def show
  	@bot = Bot.find_by(uri: params[:uri])
		if params['hub.verify_token'] == @bot.secret
			render text: params['hub.challenge'] and return
		else
			render text: 'error' and return
		end
  end

  #Receive Messages from Customers
	def receive_message
	 if params[:entry]
	   messaging_events = params[:entry][0][:messaging]
     messaging_events.each do |event|
     sender = event[:sender][:id]
     	if event[:message] != nil
     		find_reply(sender, event[:message][:text])
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

	def send_text_message(sender, text)
		@bot = Bot.find_by(uri: params[:uri])
		body = {
	   recipient: {
	     id: sender
	   },
	   message: {
	     text: text 
	   },
	  }.to_json
	  
	  response = HTTParty.post(
	   "https://graph.facebook.com/v2.6/me/messages?access_token=#{@bot.token}",
	   body: body,
	   headers: { 'Content-Type' => 'application/json' }
	  )
	end

	def find_reply(sender, text)
		#Returning the most similar question to the user
		answer = QuestionAnswer.where('user_says SIMILAR TO ?' , "%#{text.downcase}%")

		if answer.count != 0 
			send_text_message(sender, answer[0].bot_answers)
		else
			#Search from keywords
			answer = QuestionAnswer.where('keywords SIMILAR TO ?' , "%#{text.downcase}%")
			if answer.count != 0 
				send_text_message(sender, answer[0].bot_answers)
			else
			#If all really fails, then return sorry text
				send_text_message(sender, "Sorry I am still learning, I don't get what #{text} means?")
			end
		end
	end


	#Sending Image Message 
	def send_image_message(sender, image_url)
		@bot = Bot.find_by(uri: params[:uri])
		body = {
	   recipient: {
	     id: sender
	   },

	   message: {
	     attachment: {
		      type: 'image',
		      payload: {
		        url: image_url
		      }
		    }
	   }
	  }.to_json
	  
	  response = HTTParty.post(
	   "https://graph.facebook.com/v2.6/me/messages?access_token=#{@bot.token}",
	   body: body,
	   headers: { 'Content-Type' => 'application/json' }
	  )
	end

	#Sending Message Via Template
	def send_template_text(sender, text)
		@bot = Bot.find_by(uri: params[:uri])
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
	   "https://graph.facebook.com/v2.6/me/messages?access_token=#{@bot.token}",
	   body: body,
	   headers: { 'Content-Type' => 'application/json' }
	  )
	end

	#Replying Message from Buttons Postback
	def send_post_message(sender, text)
		@bot = Bot.find_by(uri: params[:uri])
		body = {
		   recipient: {
		     id: sender
		   },

		   message: {
		     text: text
		   }
		  }.to_json
		  
	  response = HTTParty.post(
	   "https://graph.facebook.com/v2.6/me/messages?access_token=#{@bot.token}",
	   body: body,
	   headers: { 'Content-Type' => 'application/json' }
	  )
	end	

  private

	def bot_params
	   params.require(:bot).permit(:name, :token, :uri, :secret)
	end	
end