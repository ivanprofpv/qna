FactoryBot.define do
  sequence(:comment_body) { |n| "test-comment-#{n}" }

  factory :comment do
    body { generate(:comment_body) }

    trait :invalid do
      body { nil }
    end
  end
end