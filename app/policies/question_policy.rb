class QuestionPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def update?
    user_author?
  end

  def destroy?
    user_author?
  end

  private

  def user_author?
    user == record.user
  end
end
