class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @micropost  = current_user.microposts.build
      @feed_items = current_user.feed.order(created_at: :desc).limit(10)
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end