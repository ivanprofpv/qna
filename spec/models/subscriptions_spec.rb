require 'rails_helper'

RSpec.describe Subscriber, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:user) }

  it 'validation' do
    user = create(:user)
    question = create(:question)
    subscription = user.subscription.create(question: question)

    expect(subscription).to validate_uniqueness_of(:question_id).scoped_to(:user_id)
  end
end
