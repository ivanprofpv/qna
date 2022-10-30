FactoryBot.define do
  factory :answer do
    user
    question
    body { "MyString answer" }

    trait :invalid do 
      body { nil }
    end
  end
end
