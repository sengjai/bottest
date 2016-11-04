class UsersController < ApplicationController
  before_action :require_login
  
  def user
  	@user=User.find(params[:id])
  end

  def edit
  	@user=User.find(params[:id])
  end

  def update
  	@user=User.find(params[:id])

  	@user.update(user_params)
	  	if @user.save
	  		redirect_to @user
	  	else
	  		render :edit
	  	end
  end




	private
	def user_params
		params.require(:user).permit(:name) #edit here to add the additional params
	end

end