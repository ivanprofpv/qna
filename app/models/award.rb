class Award < ApplicationRecord
  belongs_to :question
  belongs_to :answer, optional: true

  has_one_attached :image

  validates :title, presence: true
  validate :validate_upload_image

  private

  def validate_upload_image
    errors.add(:image, 'No image attached!') unless image.attached?
    errors.add(:image, 'You can only upload an image!') unless image.content_type =~ /^image/
  end
end
