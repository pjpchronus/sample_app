class StaticPagesController < ApplicationController
skip_before_action :logged_in_user
#before_action :logged_in_user, only: :home
skip_before_action :check_blocked
  def home
  	if logged_in?
	  	@micropost = current_user.microposts.build
	  	@feed_items = current_user.feed.paginate(page: params[:page])
	end
  end
  def help
  end

  def about
  end

  def contact
  end
end
