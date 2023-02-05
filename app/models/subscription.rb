class Subscription < ApplicationRecord
  belongs_to :question, touch: true
  belongs_to :user

  validates :question_id, uniqueness: { scope: :user_id }
end
