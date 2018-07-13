class UsersController < ApplicationController
	skip_before_action :logged_in_user, except: [:index, :edit, :update, :destroy]
	skip_before_action :check_blocked, only: [:new, :create]
	before_action :correct_user,   only: [:edit, :update]
	before_action :admin_user,     only: :destroy
	def index
		@users = User.paginate(page: params[:page])
		#@messages_to_user = current_user.sent_messages.where(receiver_id: params[:receiver_id])
		#@messages_from_user = current_user.received_messages.where(sender_id: params[:receiver_id])
	end

	def show
		@user = User.find(params[:id])
		@message = current_user.sent_messages.build(receiver_id: params[:receiver_id])
		@microposts = @user.microposts.paginate(page: params[:page])
	end

	def new
		@user = User.new
	end
	def create
		@user = User.new(user_params)
		if @user.save
			log_in @user
		  # Handle a successful save.
		  redirect_to @user
		else
		  render 'new'
		end
	end
	def block
		user = User.find(params[:id])
		user.isblocked = true
		is_saved_successfully = user.save
		if is_saved_successfully
			flash.now[:success] = "Account blocked successfully!"
		else
			flash.now[:error] = "Something went wrong. Please try again later."
		end
		redirect_back(fallback_location: users_path)
	end

	def unblock
		user = User.find(params[:id])
		user.isblocked = false
		is_saved_successfully = user.save
		if is_saved_successfully
			flash.now[:success] = "Account unblocked successfully!"
		else
			flash.now[:error] = "Something went wrong. Please try again later."
		end
		flash.now[:success] = "Account unblocked successfully!"
		redirect_back(fallback_location: users_path)
	end


	def destroy
	    User.find(params[:id]).destroy
	    flash[:success] = "User deleted"
	    redirect_to users_url
	  end
	def edit
		@user = User.find(params[:id])
	end
	
	def update
	    @user = User.find(params[:id])
	    if @user.update_attributes(user_params)
	      # Handle a successful update.
	      flash[:success] = "Profile updated"
      	  redirect_to @user
	    else
	      render 'edit'
	    end
	 end
	def following
		@title = "Following"
		@user  = User.find(params[:id])
		@users = @user.following.paginate(page: params[:page])
		render 'show_follow'
	end

	def followers
		@title = "Followers"
		@user  = User.find(params[:id])
		@users = @user.followers.paginate(page: params[:page])
		render 'show_follow'
	end

	private

	def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
	# def logged_in_user
 #      unless logged_in?
 #      	store_location
 #        flash[:danger] = "Please log in."
 #        redirect_to login_url
 #      end
 #    end
    # Confirms the correct user.
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
     end
	def user_params
	  params.require(:user).permit(:name, :email, :password,
	                               :password_confirmation)
	end
end