class User < ActiveRecord::Base
  has_many :articles, dependent: :destroy
  has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy
  has_many :followers, through: :passive_relationships, source: :follower                                
  attr_accessor :password
  before_save :add_salt_and_hash
  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, on: :create,
    length: { minimum: 5 },
    confirmation: true
  def add_salt_and_hash
    unless password.blank?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end
  # include Humanizer
  # require_human_on :create

  before_create :add_activation_token

  def add_activation_token
    self.activation_token = SecureRandom.urlsafe_base64
    self.activation_status = "not activated"
  end
  def feed
    following_ids = "SELECT followed_id FROM relationships
                     WHERE  follower_id = :user_id"
    Article.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: id)
  end
  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end
  def following?(other_user)
    following.include?(other_user)
  end
end
