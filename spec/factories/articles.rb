FactoryBot.define do
  factory :article do
    title { "Sample Article Title" }
    content { "Sample article body comes here." }
    slug { "sample-article-title" }
  end
  factory :article2 do
    title { "Sample Article Title" }
    content { "Sample article body comes here." }
    slug { "sample-article-title" }
  end
end
