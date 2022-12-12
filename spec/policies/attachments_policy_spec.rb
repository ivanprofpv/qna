require 'rails_helper'

RSpec.describe AttachmentsPolicy, type: :policy do
  include ActionDispatch::TestProcess::FixtureFile
  let(:user) { create :user }
  let!(:file) { fixture_file_upload("#{Rails.root}/spec/rails_helper.rb", 'text/plain') }
  let(:attachment) { create(:question, user: user, files: [file]) }

  subject { described_class }

  permissions :destroy? do
    it 'user access to delete their file' do
      expect(subject).to permit(user, attachment.files.first.record)
    end
  end
end
