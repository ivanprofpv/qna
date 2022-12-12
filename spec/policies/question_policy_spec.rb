require 'rails_helper'

RSpec.describe QuestionPolicy, type: :policy do
  subject { described_class.new(user, question) }

  context 'authenticated user (not author)' do
    let(:user) { create :user }
    let(:question) { create(:question, user: create(:user)) }

    it { should_not permit_action(:update) }
    it { should_not permit_action(:destroy) }
  end

  context 'authenticated user (author)' do
    let(:user) { create :user }
    let(:question) { create(:question, user: user) }

    it { should permit_action(:update) }
    it { should permit_action(:destroy) }
  end
end
