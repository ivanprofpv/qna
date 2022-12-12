require 'rails_helper'

RSpec.describe AnswerPolicy, type: :policy do
  subject { described_class.new(user, answer) }

  context 'authenticated user (not author)' do
    let(:user) { create :user }
    let(:answer) { create(:answer, user: create(:user)) }

    it { should_not permit_action(:update) }
    it { should_not permit_action(:destroy) }
  end

  context 'authenticated user (author)' do
    let(:user) { create :user }
    let(:answer) { create(:answer, user: user) }

    it { should permit_action(:update) }
    it { should permit_action(:destroy) }
  end

  context 'authenticated user (and author) can assign the best answer' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, question: question, user: create(:user)) }

    it { should permit_action(:best) }
  end
end
