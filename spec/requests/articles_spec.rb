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
      body = JSON.parse(response.body)   #ovo nekak raspakira JSON da je lakše radit s njim
      expect(body).to eq(
        data:  [
          {
            id: article.id,
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
