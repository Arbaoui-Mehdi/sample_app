class User < ApplicationRecord

  #
  #
  # Associations
  has_many :microposts,
           dependent: :destroy # Destroy associated user microposts

  # Active
  has_many :active_relationships, class_name:  'Relationship',
           foreign_key: 'follower_id',
           dependent:   :destroy

  has_many :following,
           through: :active_relationships,
           source: :followed

  # Passive
  has_many :passive_relationships, class_name:  'Relationship',
           foreign_key: 'followed_id',
           dependent:   :destroy

  has_many :followers,
           through: :passive_relationships,
           source: :follower

  #
  #
  #
  attr_accessor :remember_token,
                :activation_token,
                :reset_token

  #
  #
  # Before Creating The User
  before_create :create_activation_digest

  #
  #
  # Before Saving The User
  before_save :downcase_email

  #
  #
  # Name Validation
  validates :name,
            presence: true,
            length: { maximum: 50 }

  #
  #
  # Email Validation
  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\-.]+\.[a-z]+\z/i
  validates :email,
            presence: true,
            length: { maximum: 255 },
            format: { with: EMAIL_REGEX },
            uniqueness: { case_sensitive: false }

  #
  #
  # Password
  has_secure_password
  validates :password,
            length: { minimum: 6 },
            allow_blank: true

  #
  #
  # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password::create(string, cost: cost)
  end

  #
  #
  # Returns a random token.
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  #
  #
  # Remembers a user in teh database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  #
  #
  # Returns true if the given token matches the digest.
  def authenticated?(attribute, token)
    digest = self.send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  #
  #
  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end

  #
  #
  # Activates an Account
  def activate
    self.update_attribute(:activated, true)
    self.update_attribute(:activated_at, Time.zone.now)
  end

  #
  #
  # Send Activation Email
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  #
  #
  # Sets the password reset attributes
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest, User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  #
  #
  # Send password reset email.
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  #
  #
  # Returns true if a password reset has expired
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  #
  # Defines a proto-feed
  # Returns a user's status feed.
  # following_ids is the equivalent of User.first.following.map(&:id)
  def feed
    following_ids_subselect = 'SELECT followed_id FROM relationships WHERE follower_id = :user_id'

    # SELECT * from microposts
    # WHERE user_id IN (SELECT followed_id FROM relationships WHERE follower_id = 1)
    # or user_id = 1
    Micropost.where(
        "user_id IN (#{following_ids_subselect})
         OR user_id = :user_id", user_id: id
    )

  end

  #
  #
  # Follows a User
  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end

  #
  #
  # Unfollows a User
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  #
  #
  # Returns true if the current user is following the other user
  def following?(other_user)
    self.following.include?(other_user)
  end

  #
  #
  # Private
  private

    #
    #
    # Converts email to all lower-case.
    def downcase_email
      self.email = email.downcase
    end

    #
    #
    # Creates and assigns the activation token and digest
    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end

end
