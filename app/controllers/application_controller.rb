class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :logged_in_user
  before_action :check_blocked


  include SessionsHelper
  private
  	def check_blocked
  		if current_user.isblocked
  			log_out
  			flash[:danger] = "Your account is blocked!!"
  			redirect_to login_url
  		end
  	end
   # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
end