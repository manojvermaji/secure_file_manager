class FileUpload < ApplicationRecord
  belongs_to :user
  has_one_attached :file

  before_create :generate_share_token

  validates :title, :description, presence: true

  def generate_share_token
    self.share_token = SecureRandom.uuid
  end

  def file_type
    file.content_type
  end

  def public?
    self.public
  end

  def short_url
    Rails.application.routes.url_helpers.public_file_url(self.share_token)
  end
end
