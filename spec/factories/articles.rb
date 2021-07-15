FactoryBot.define do
  factory :article do
    sequence(:title)  { |n| "Sample article #{n}"}
    content { "Sample article body comes here." }
    sequence(:slug) { |n| "sample-article-#{n}" }
  end
end
