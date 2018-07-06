class SessionsController < ApplicationController
  skip_before_action :logged_in_user, except: [:destroy]
  skip_before_action :check_blocked, except: [:destroy]
  def new
  	render 'new'
  end
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
    	log_in user
    	if user.isblocked
    		check_blocked
    	else
	    	redirect_to user
	    end
      # Log the user in and redirect to the user's show page.
    else
      # Create an error message.
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
  	log_out
    redirect_to root_url
  end
end
