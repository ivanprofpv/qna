require 'rails_helper'

RSpec.describe LinksPolicy, type: :policy do
  let(:user) { create :user }
  let(:question) { create(:question, user: user) }
  let(:link) { create(:link, linkable: question) }

  subject { described_class }

  permissions :destroy? do
    it 'user access to delete their link' do
      expect(subject).to permit(user, link.linkable)
    end
  end
end
