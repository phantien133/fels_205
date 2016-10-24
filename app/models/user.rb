class User < ApplicationRecord
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

  private
    def format_value
      self.email = email.downcase
      unless self.phone.nil?
        self.phone.gsub! " ",""
        self.phone.gsub! "-",""
        self.phone.gsub! "(",""
        self.phone.gsub! ")",""
      end
    end
end
