class User < ApplicationRecord

  has_many :microposts, dependent: :destroy
  has_many :values, dependent: :destroy


  validates :name, presence: true, uniqueness: true, length: {maximum:50}

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true,
            uniqueness: { case_sensitive: false },
            format: { with: VALID_EMAIL_REGEX }

  has_secure_password
  validates :password_digest, length: { minimum: 6 }


  before_create :create_remember_token, :create_password_hash
  before_save { self.email = email.downcase }
  # before_save { email.downcase! } # alternative


  def self.all_cached
    Rails.cache.fetch('User.all') { all }
  end

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    #Digest::SHA1.hexdigest("#{salt}#{real_password}")
    Digest::SHA1.hexdigest(token.to_s)
  end

  private

  def create_remember_token
    self.remember_token = User.encrypt(User.new_remember_token)
  end

  def create_password_hash
    sha1_password = Digest::SHA1.hexdigest(self.password_digest)
    self.password_digest = BCrypt::Password.create(sha1_password).to_s
  end
end
