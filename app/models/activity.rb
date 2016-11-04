
class Activity < ApplicationRecord
  belongs_to :user

  enum activity_types: [:created, :updated, :removed]

  validates :target_id, presence: true
  validates :target_type, presence: true
  validates :action_type, presence: true

  scope :users_activities, ->user_id do
    where("user_id = :user_id OR user_id IN (SELECT followed_id
      FROM relationships WHERE follower_id = :user_id)", user_id: user_id)
    .order created_at: :desc
  end

  def get_activity_info_user
    activity_display_element = {found_target: false, target: nil, action: nil}
    user = User.find_by(id: target_id)
    if user
      activity_display_element[:target] = user
      activity_display_element[:found_target] = true
    else
      activity_display_element[:target] = target_id
    end
    case action_type
    when Activity.activity_types[:created].to_s
      activity_display_element[:action] = I18n.t :follow
    when Activity.activity_types[:removed].to_s
      activity_display_element[:action] = I18n.t :unfollow
    else
      activity_display_element = nil
    end

    return activity_display_element
  end

  def get_activity_info_lesson
    activity_display_element = {found_target: false, target: nil, lesson: nil, action: nil}
    result = Result.find_by(id: target_id)
    lesson = Lesson.unscoped.find_by id: result.lesson_id
    if result
      activity_display_element[:target] = result
      activity_display_element[:lesson] = lesson
      activity_display_element[:found_target] = 2
    else
      activity_display_element[:target] = target_id
      activity_display_element[:found_target] = false
    end
    case action_type
    when Activity.activity_types[:created].to_s
      activity_display_element[:action] = I18n.t :start_lesson
    when Activity.activity_types[:updated].to_s
      activity_display_element[:action] = I18n.t :finish_lesson
    else
      activity_display_element = nil
    end

    return activity_display_element
  end
end
