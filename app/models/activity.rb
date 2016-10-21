class Activity < ApplicationRecord
  belongs_to :user
  validates :tagget_id, presence: true
  validates :tagget_type, presence: true
  validates :action_type, presence: true
end
