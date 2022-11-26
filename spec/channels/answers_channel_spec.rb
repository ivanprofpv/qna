require 'rails_helper'

RSpec.describe AnswersChannel, type: :channel do
  it "subscription without streams" do
    subscribe question: 1

    expect(subscription).to be_confirmed
  end
end
