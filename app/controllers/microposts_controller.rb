class MicropostsController < ApplicationController
  before_action :require_user
  before_action :set_micropost, :require_author, only: %i[destroy toggle_pinned]

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

  def set_micropost
    @micropost = Micropost.find(params[:id])
  end

  def require_author
    return if @micropost.user == current_user

    redirect_to root_path, status: :see_other, flash: { danger: 'Unauthorized' }
  end
end
