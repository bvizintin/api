require 'rails_helper'

RSpec.describe ArticlesController do
  describe "#index" do
    it "returns a success response" do
      get "/articles"        # moram prvo poslati get request
      expect(response).to have_http_status(:ok)
      #expect(response.status).to eq(200)        #ista stvar
    end

    it "returns a valid JSON" do
      article= create(:article)    #FactoryBot
      get "/articles"
      body = JSON.parse(response.body).deep_symbolize_keys      #ovo nekak raspakira JSON da je lakše radit s njim. Umjesto u string raspakira ga u hash
      pp body                                               # sa pp naredbom možemo indentirano printat unutar testa, da vidimo i debugiramo rezultate. p==inspect, pp=pretty_inspect
      expect(body).to eq(
        data:  [
          {
            id: article.id.to_s,
            type: "articles",
            attributes: {
              title: article.title,
              content: article.content,
              slug: article.slug
            }
          }
        ]
      )
    end
  end
end
