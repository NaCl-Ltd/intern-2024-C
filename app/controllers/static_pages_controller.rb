class StaticPagesController < ApplicationController

  def home
    if logged_in?
      @micropost  = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
      
     
      @users = User.all
      @users_nicknames_and_urls = @users.each_with_object({}) do |user, hash|
        hash[user.nickname] = user_path(user)
      end

      
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end
