class User < ActiveRecord::Base
  authenticates_with_sorcery!
  has_many :products, dependent: :destroy
  before_save { self.email = email.downcase }
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
            uniqueness: { case_sensitive: false },
            email_format: { message: 'has invalid format' }
  validates :password, presence: true, length: { minimum: 6 }, confirmation: true, if: :new_user?
  mount_uploader :picture, PictureUploader
  validate :picture_size

  # defines a proto-feed
  def feed
    Product.where("user_id = ?", id)
  end

  private
    def new_user?
      new_record?
    end

    # Validates the size of an uploaded picture.
    def picture_size
      if picture.size > 2.megabytes
        errors.add(:picture, "should be less than 5MB")
      end
    end

end
