require 'rails_helper'

RSpec.describe Award, type: :model do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  it { should validate_presence_of :title }
  it { should belong_to(:answer).optional }
  it { should belong_to(:question) }

  it 'one image attached' do
    expect(Award.new.image).to be_an_instance_of(ActiveStorage::Attached::One)
  end

  it 'validate image for award' do
    expect(Award.new(title: 'Award title', question: question)).to_not be_valid
    expect(Award.new(title: 'Award title', question: question, image: Rack::Test::UploadedFile.new("#{Rails.root}/spec/rails_helper.rb", 'text/plain'))).to_not be_valid
    expect(Award.new(title: 'Award title', question: question, image: Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/award_image.png", 'image/png'))).to be_valid
  end
end