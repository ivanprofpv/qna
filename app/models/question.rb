class Question < ApplicationRecord

  include Votable
  include Commentable

  belongs_to :user

  has_many :answers, -> { order(best: :desc) }, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  has_many :subscriptions, dependent: :destroy
  has_one :award, dependent: :destroy
  has_many_attached :files

  accepts_nested_attributes_for :links, :award, reject_if: :all_blank, allow_destroy: true

  validates :title, :body, presence: true

  after_create :calculate_reputation
  after_create :subscription_author

  def user_subscription?(user)
    subscriptions.find_by(user: user)
  end

  private

  def subscription_author
    subscriptions.create(user: user)
  end

  def calculate_reputation
    ReputationJob.perform_later(self)
  end
end
