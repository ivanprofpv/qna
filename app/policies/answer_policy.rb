class AnswerPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    user.present?
  end

  def update?
    user_author?
  end

  def destroy?
    user_author?
  end

  def best?
    user == record.question.user
  end

  private

  def user_author?
    user == record.user
  end
end
