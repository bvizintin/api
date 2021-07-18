require 'rails_helper'

RSpec.describe ArticlesController do
  describe "#index" do
    it "returns a success response" do
      get "/articles"        # moram prvo poslati get request
      expect(response).to have_http_status(:ok)
      #expect(response.status).to eq(200)        #ista stvar
    end

    it "returns a valid JSON" do      # !!!expandaj sekciju
      article= create(:article)    #FactoryBot
      get "/articles"
      body = JSON.parse(response.body).deep_symbolize_keys      #ovo nekak raspakira JSON da je lakše radit s njim. Umjesto u string raspakira ga u hash
      #nakon kaj sam definirao ApiHelpers mogu samo pozvati:
      # body = json
      pp body                                               # sa pp naredbom možemo indentirano printat unutar testa, da vidimo i debugiramo rezultate. p==inspect, pp=pretty_inspect
      #expect(body).to eq(                                   # ovdje sada mogu pozvati expect(json_data),
        # data:  [                                            # ..tada mičem i "data:" key
        #   {
        #     id: article.id.to_s,
        #     type: "articles",
        #     attributes: {
        #       title: article.title,
        #       content: article.content,
        #       slug: article.slug
        #     }
        #   }
        # ]
      #)
# malo ću urediti ispis prethodnog testa da ga je lakše debugirati

      expect(json_data.length).to eq(1)
      expected = json_data.first
      aggregate_failures do
        expect(expected[:id]).to eq(article.id.to_s)
        expect(expected[:type]).to eq("articles")
        expect(expected[:attributes]).to eq(
                title: article.title,
                content: article.content,
                slug: article.slug
        )
      end
    end

    it "return articles in the proper order" do
      older_article = create(:article, created_at: 1.hour.ago)
      recent_article = create(:article)
      get "/articles"
      puts "Testing the order"
      pp json_data
      expect(json_data.first[:id].to_i).to be > (json_data.last[:id].to_i)
      recent_article.update_column(:created_at, 2.hours.ago)               #provjera jel test otporan na izmjene
      expect(json_data.first[:id].to_i).to be > (json_data.last[:id].to_i)
    end

    it "paginates results" do
      article1, article2, article3 = create_list(:article, 3)
      get "/articles", params: { page: {number: 2, size: 1}}
      expect(json_data.length).to eq(1)
      expect(json_data.first[:id]).to eq("#{article2.id}")
    end

    it "contains pagination links" do
      article1, article2, article3 = create_list(:article, 3)
      get "/articles", params: { page: {number: 2, size: 1}}
      expect(json[:links].length).to eq(5)
    end
  end

  describe "#show" do
    let(:article) {create(:article)}
    subject {get "/articles/#{article.id}"}
    before {subject}

    it "returns success response" do
      pp response.status
      expect(response).to have_http_status(:ok)
    end

    it "returns a proper json" do
      pp json_data
      aggregate_failures do
        expect(json_data[:id]).to eq("#{article.id}")
        expect(json_data[:type]).to eq("articles")
        expect(json_data[:attributes]).to eq(title: article.title, content: article.content, slug: article.slug)
      end
    end

  end
end
