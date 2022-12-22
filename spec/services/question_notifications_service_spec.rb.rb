require 'rails_helper'

RSpec.describe QuestionNotificationsService do
  subject(:notification_service) { described_class.new(question) }

  let(:users) { create_list(:user, 2) }
  let(:question) { create(:question, user: users.first) }

  before do
    question.subscriptions.create(user: users.first)
    question.subscriptions.create(user: users.last)
  end

  it 'send notifications' do
    users.each do |user|
      expect(QuestionNotificationsMailer).to receive(:notify).with(question, user).and_call_original
    end

    notification_service.call
  end
  
end