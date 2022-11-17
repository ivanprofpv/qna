require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to :user }
  it { should belong_to :votable }

  let(:author) { create(:user) }
  let(:votable) { create(:question, user: author) }

  describe 'Author cannot vote on their own question or answer' do
    it 'error when trying to vote' do
      vote = described_class.new(user_id: author.id, votable: votable, vote_weight: 1)
      vote.valid?
      expect(vote.errors[:user]).to include("You can't upvote your own question")
    end
  end
end
