class StaticPagesController < ApplicationController
skip_before_action :logged_in_user, only: [:help, :about, :contact]
before_action :logged_in_user, only: :home
before_action :check_blocked, only: :home
  def home
  	@micropost = current_user.microposts.build
  	@feed_items = current_user.feed.paginate(page: params[:page])
  end
  def help
  end

  def about
  end

  def contact
  end
end
