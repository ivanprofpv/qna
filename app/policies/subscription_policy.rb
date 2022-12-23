class SubscriptionPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end

  def create?
    user.present?
  end

  def destroy?
    user_author?
  end

  private

  def user_author?
    user == record.user
  end
end
