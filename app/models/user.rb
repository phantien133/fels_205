class User < ApplicationRecord
  attr_accessor :protected_token
  has_many :lessions
  has_many :activeties, dependent: :destroy
  has_many :active_relationships,
    class_name: Relationship.name,
    foreign_key: :follower_id,
    dependent: :destroy
  has_many :following, through: :active_relationships,
    source: :followed
  has_many :passive_relationships,
    class_name: Relationship.name,
     foreign_key: :followed_id,
     dependent: :destroy
  has_many :followers, through: :passive_relationships,
    source: :follower

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :name, presence: true, length: {maximum: 50}
  validates :email, presence: true, length: {maximum: 255},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: false}

  VALID_PHONE_REGEX = /[+]?[\d]+[^a..z][^A..Z][^\B]\z/
  validates :phone, presence: true,
    format: {with: VALID_PHONE_REGEX},
    length: {minimum: 6, maximum: 12},
    allow_nil: true

  has_secure_password
  validates :password, presence: true,
    length: {minimum: 6}, allow_nil: true

  before_save :format_value

  mount_uploader :avatar, PictureUploader

  class << self
    def new_token
      SecureRandom.urlsafe_base64
    end

    def digest string
      cost = BCrypt::Engine::MIN_COST
      BCrypt::Password.create string, cost: cost
    end
  end

  def authenticated? token
    return false if protected_digest.nil?
    BCrypt::Password.new(self.protected_digest).is_password? token
  end

  def remember
    self.protected_token = User.new_token
    update_attribute :protected_digest, User.digest(protected_token)
  end

  def forget
    self.update_attribute :protected_digest, nil
  end

  private
    def format_value
      self.email = email.downcase
    end
end
