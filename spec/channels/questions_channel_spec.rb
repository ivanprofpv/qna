require 'rails_helper'

RSpec.describe QuestionsChannel, type: :channel do
  it "subscribes without streams" do
    subscribe

    expect(subscription).to be_confirmed
  end
end
