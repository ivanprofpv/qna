class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true

  enum vote_weight: { dislike: -1, like: 1 }

  validate :does_not_vote_for_himself

  private

  def does_not_vote_for_himself
    if user&.author?(votable)
      errors.add(:user, "You can't upvote your own question")
    end
  end
end
