class MicropostsController < ApplicationController
skip_before_action :logged_in_user, except: [:create, :destroy]
skip_before_action :check_blocked, except: [:create, :destroy]
before_action :correct_user,   only: :destroy
def create
@micropost = current_user.microposts.build(micropost_params)
	if @micropost.save
	  flash[:success] = "Micropost created!"
	  redirect_to root_url
	else
	  @feed_items = current_user.feed.paginate(page: params[:page])
	  render 'static_pages/home'
	end
end

def like
	other_mp = Micropost.find(params[:id])
	other_mp.liked_by current_user
	redirect_back(fallback_location: users_path)
end

def unlike
	other_mp = Micropost.find(params[:id])
	other_mp.unliked_by current_user
	redirect_back(fallback_location: users_path)
end

 def destroy
    @micropost.destroy
    flash[:success] = "Micropost deleted"
    redirect_to request.referrer || root_url
  end
 private

    def micropost_params
      params.require(:micropost).permit(:content, :picture)
    end
     def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
end