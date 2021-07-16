class ArticleSerializer
  include JSONAPI::Serializer
  set_type :articles       #defaultna vrijednost je "article"
  attributes :title, :content, :slug
end
