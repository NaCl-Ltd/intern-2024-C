class Micropost < ApplicationRecord
  include Discard::Model

  belongs_to :user
  has_many_attached :images do |attachable|
    attachable.variant :display, resize_to_limit: [200, 200]
  end

  has_many :likes, as: :likeable, dependent: :destroy
  has_and_belongs_to_many :tags

  default_scope -> { order(pinned: :desc, created_at: :desc) }

  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validates :images, content_type: { in: %w[image/jpeg image/gif image/png],
                                      message: "must be a valid image format" },
                      size:         { less_than: 5.megabytes,
                                      message:   "should be less than 5MB" }
  validate :images_limit

  before_update :add_tags
  after_create :add_tags

  after_save :ensure_single_pinned_post, if: -> { pinned? }

  private

  def images_limit
    if images.size > 4
      errors.add(:images, "cannot post more than 4")
    end
  end

  def ensure_single_pinned_post
    update!(pinned: false) if discarded?

    user.microposts.where(pinned: true).where.not(id: id).update_all(pinned: false)
  end

  def add_tags
    tags.clear
    self.tags = content.scan(/#[^\s#]+/).uniq.map do |hashtag|
      Tag.find_or_create_by!(name: hashtag.downcase[1..])
    end
  end
end
