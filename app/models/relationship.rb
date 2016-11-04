class Relationship < ApplicationRecord
  belongs_to :follower, class_name: User.name
  belongs_to :followed, class_name: User.name
  validates :follower_id, presence: true
  validates :followed_id, presence: true

  after_create :create_follow_activity
  after_destroy :create_unfollow_activity

  private
  def create_follow_activity
    create_activity Activity.activity_types[:created]
  end

  def create_unfollow_activity
    create_activity Activity.activity_types[:removed]
  end

  def create_activity action_type
    Activity.create user_id: self.follower_id, target_id: self.followed_id, target_type: User.name,
      action_type: action_type
  end
end
