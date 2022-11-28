FactoryBot.define do
  factory :comment do
    commentable { nil }
    user
    body { 'Comment' }

    trait :invalid do
      body { nil }
    end
  end
end
