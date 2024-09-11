class MicropostsController < ApplicationController
  before_action :require_user
  before_action :set_micropost, only: %i[update destroy toggle_pinned like unlike]
  before_action :require_author, only: %i[update destroy toggle_pinned]

  def index
    @micropost  = current_user.microposts.build
    @feed_items = current_user.feed.order(created_at: :desc)
  end

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      @feed_items = current_user.feed.order(created_at: :desc).limit(10) 
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
    @microposts = Micropost.includes(:user, images_attachments: :blob)
                           .kept
                           .where(user_id: current_user.following_ids, created_at: 48.hours.ago..)
                           .reorder('created_at DESC')
                           .limit(Settings.news.count)
  end

  def trash
    @microposts = Micropost.includes(:user, images_attachments: :blob)
                           .discarded
                           .paginate(page: params[:page])
  end

  def likes
    @microposts = Micropost.includes(:user, images_attachments: :blob)
                           .kept
                           .where(id: current_user.likes.pluck(:likeable_id))
                           .paginate(page: params[:page])
  end

  def toggle_pinned
    @micropost.toggle(:pinned).save!
    redirect_to root_path, status: :see_other
  end

  def like
    current_user.likes.create!(likeable: @micropost)
    render turbo_stream: turbo_stream.replace(
      @micropost,
      partial: 'microposts/like_btn',
      locals: { micropost: @micropost }
    )
  end

  def unlike
    current_user.likes.find_by(likeable: @micropost).destroy!
    render turbo_stream: turbo_stream.replace(
      @micropost,
      partial: 'microposts/like_btn',
      locals: { micropost: @micropost }
    )
  end

  private

  def micropost_params
    params.require(:micropost).permit(:content, images: [])
  end

  def set_micropost
    @micropost = Micropost.find(params[:id])
  end

  def require_author
    return if @micropost.user == current_user || current_user.admin?

    redirect_to root_path, status: :see_other, flash: { danger: 'Unauthorized' }
  end
end
