class User < ApplicationRecord
	has_many :active_relationships, class_name:  "Relationship",
	                                  foreign_key: "follower_id",
	                                  dependent:   :destroy
	has_many :passive_relationships, class_name:  "Relationship",
	                           foreign_key: "followed_id",
	                           dependent:   :destroy
	has_many :microposts, dependent: :destroy
	has_many :following, through: :active_relationships, source: :followed
	has_many :followers, through: :passive_relationships, source: :follower	

	has_many :sent_messages, class_name: "Message", foreign_key: "sender_id", dependent: :destroy
	has_many :received_messages, class_name: "Message", foreign_key: "receiver_id", dependent: :destroy
	#has_many :messages, dependent: :destroy

	before_save { self.email = email.downcase }
	validates :name, presence: true, length: { maximum: 50 }
	VALID_EMAL_REGEX =  /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
	validates :email, presence: true, length: { maximum: 255 },
				format: { with: VALID_EMAL_REGEX },
				uniqueness: { case_sensitive: false }				
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  # Returns the hash digest of the given string.
  acts_as_voter

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  # See "Following users" for the full implementation.
  def feed
    Micropost.where("user_id IN (?) OR user_id = ?", following_ids, id)
  end

  def name(name_only = false)
    if !self.attributes["name"].nil?
      self.attributes["name"] + (self.admin? && !name_only ? " (Admin)" : "")
    else
      self.attributes["name"]
    end
  end

	

  # Follows a user.
  def follow(other_user)
    following << other_user
  end

  # Unfollows a user.
  def unfollow(other_user)
    following.delete(other_user)
  end

  # Returns true if the current user is following the other user.
  def following?(other_user)
    following.include?(other_user)
  end
end
