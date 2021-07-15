require 'rails_helper'

RSpec.describe Article, type: :model do

  describe "#validations" do
    let(:article) { FactoryBot.create(:article)}

    it "test the Article object" do
      #article= FactoryBot.build(:article)                       #"build" je isto ko "create", ali ne sejva u bazu, jer nam to još ne treba
      expect(article.title).to eq("Sample article 1")
      expect(article).to be_valid                               #provjerava "validates" uvjete iz Artice.rb modela
    end

    it "has and invalid title" do
      #article = build(:article, title: "")                      #"build" je isto ko "FactoryBot.build" jer koristimo FactoryBot::Syntax. Ovdje namjerno kreiram prazni naslov.
      article.title = ""
      expect(article).not_to be_valid
      expect(article.errors[:title]).to include("can't be blank")
    end

    it "has an invalid content" do
      article.content = ""
      expect(article).not_to be_valid
    end

    it "has invalid slug" do
      article.slug = ""
      expect(article).not_to be_valid
    end

    it "verifies the uniqueness of the slug" do
      article2 = FactoryBot.build(:article, slug: article.slug)    #ne sejvam ga u bazu pa koristim build, jer mi validation nebi dao sejvat
      expect(article2).not_to be_valid
    end
  end
end
