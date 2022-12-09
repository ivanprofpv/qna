require 'rails_helper'

RSpec.describe AnswerPolicy, type: :policy do
  let(:user) { create :user }
  let(:other_user) { create :user }
  let(:admin) { create :user, admin: true }

  subject { described_class }

  # permissions ".scope" do
  #   pending "add some examples to (or delete) #{__FILE__}"
  # end

  # permissions :show? do
  #   pending "add some examples to (or delete) #{__FILE__}"
  # end

  # permissions :create? do
  #   pending "add some examples to (or delete) #{__FILE__}"
  # end

  permissions :update? do
    it 'grants access if user is admin' do
      expect(subject).to permit(admin, create(:answer))
    end

    it 'grants access if user is author' do
      expect(subject).to permit(user, create(:answer, user: user))
    end

    it 'denies access if user is not author' do
      expect(subject).not_to permit(other_user, create(:answer, user: user))
    end
  end

  # permissions :destroy? do
  #   pending "add some examples to (or delete) #{__FILE__}"
  # end
end
