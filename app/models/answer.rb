class Answer < ApplicationRecord

  include Votable
  include Commentable

  belongs_to :question
  belongs_to :user

  has_many_attached :files
  has_many :links, dependent: :destroy, as: :linkable
  has_one :award, dependent: :destroy

  validates :body, presence: true

  accepts_nested_attributes_for :links, :award, reject_if: :all_blank, allow_destroy: true

  after_create :notify_question_subscribers

  def set_best
    Answer.transaction do
      Answer.where(question_id: question_id, best: true).update_all(best: false)
      update!(best: true)
      if question.award
        update!(award: question.award)
      end
    end
  end

  private

  def notify_question_subscribers
    QuestionNotificationsJob.perform_later(question)
  end
end
