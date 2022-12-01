require 'rails_helper'

RSpec.describe CommentsChannel, type: :channel do
  it 'test subscribes' do
    subscribe

    expect(subscription).to be_confirmed
  end
end
