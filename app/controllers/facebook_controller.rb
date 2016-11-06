class FacebookController < ApplicationController
  def index
  	oauth_access_token = current_user.authentications[0].token
  	graph = Koala::Facebook::API.new(oauth_access_token)
  	@pages = graph.get_object("me/accounts")
  end

  def show
  end

  def send_message
  	
  end
end
