class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i[create destroy news toggle_pinned]
  before_action :correct_user, only: %i[destroy toggle_pinned]

  def create
    @micropost = current_user.microposts.build(micropost_params)
    @micropost.image.attach(params[:micropost][:image])
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      @feed_items = current_user.feed.paginate(page: params[:page])
      render 'static_pages/home', status: :unprocessable_entity
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = "Micropost deleted"
    if request.referrer.nil?
      redirect_to root_url, status: :see_other
    else
      redirect_to request.referrer, status: :see_other
    end
  end

  def news
    @microposts = Micropost.includes(:user, image_attachment: :blob)
                           .where(user_id: current_user.following_ids, created_at: 48.hours.ago..)
                           .reorder('created_at DESC')
                           .limit(Settings.news.count)
  end

  def toggle_pinned
    @micropost.toggle(:pinned).save!
    redirect_to root_path, status: :see_other
  end

  private

    def micropost_params
      params.require(:micropost).permit(:content, :image)
    end

    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url, status: :see_other if @micropost.nil?
    end
end
