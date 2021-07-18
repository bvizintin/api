FactoryBot.define do
  factory :user do
    sequence(:login) { |n| "User number #{n}" }
    name { "John Wicks" }
    url { "http://example.com" }
    avatar_url { "http://example.com/avatar" }
    provider { "github" }
  end
end
