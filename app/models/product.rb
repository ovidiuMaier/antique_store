class Product < ActiveRecord::Base
  belongs_to :user
  default_scope -> {order(created_at: :desc) }
  validates :user_id, presence: true
  validates :title, :description, presence: true
  validates :price, numericality: {greater_than_or_equal_to: 0.01}
  validates :title, uniqueness: true
  validates :image_url, allow_blank: true, format: {
  with:    %r{\.(gif|jpg|png)\Z}i,
  message: 'must be a URL for GIF, JPG or PNG image.'
  }
end
