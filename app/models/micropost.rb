class Micropost < ApplicationRecord
  belongs_to :user
  default_scope -> { order('created_at DESC') }
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validate  :picture_size
  
  
  #
  #
  # Validates the size of an uploader picture
  def picture_size
    if picture.size > 1.megabytes
      errors.add(:picture, 'should be less than 1MB')
    end
  end
  
end
