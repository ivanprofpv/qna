require 'rails_helper'

RSpec.describe QuestionNotificationsJob, type: :job do
  let(:service) { double('QuestionNotificationsService') }
  let(:question) { create(:question) }

  before do
    allow(QuestionNotificationsService).to receive(:new).with(question).and_return(service)
  end

  it 'calls QuestionNotificationsService#call' do
    expect(service).to receive(:call)
    QuestionNotificationsJob.perform_now(question)
  end
end
