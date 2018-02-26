class User < ApplicationRecord
  mount_uploader :avatar, AvatarUploader
  has_secure_password
  validates :name, {presence: true}
  validates :email, {presence: true , uniqueness: true}

  def posts
    return Post.where(user_id: self.id).order(created_at: :desc)
  end
end
