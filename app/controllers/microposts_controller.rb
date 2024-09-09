class MicropostsController < ApplicationController
  before_action :require_user
  before_action :set_micropost, :require_author, only: %i[update destroy toggle_pinned]

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      @feed_items = current_user.feed.paginate(page: params[:page])
      render 'static_pages/home', status: :unprocessable_entity
    end
  end

  def update
    @micropost.undiscard
    redirect_back_or_to root_path, flash: { success: 'Micropost restored' }
  end

  def destroy
    @micropost.discard || @micropost.destroy!
    redirect_back_or_to root_path, status: :see_other, flash: { success: 'Micropost deleted' }
  end

  def news
    @microposts = Micropost.includes(:user, image_attachment: :blob)
                           .kept
                           .where(user_id: current_user.following_ids, created_at: 48.hours.ago..)
                           .reorder('created_at DESC')
                           .limit(Settings.news.count)
  end

  def trash
    @microposts = Micropost.includes(:user, image_attachment: :blob)
                           .discarded
                           .paginate(page: params[:page])
  end

  def toggle_pinned
    @micropost.toggle(:pinned).save!
    redirect_to root_path, status: :see_other
  end

  private

  def micropost_params
    params.require(:micropost).permit(:content, images: [])
  end

  def set_micropost
    @micropost = Micropost.find(params[:id])
  end

  def require_author
    return if @micropost.user == current_user

    redirect_to root_path, status: :see_other, flash: { danger: 'Unauthorized' }
  end
end
