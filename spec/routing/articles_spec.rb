require 'rails_helper'

RSpec.describe "/articles roues" do
  it "routes to articles#index" do
    #expect(get "/articles").to route_to(controller: "articles"  , action: "index")     #ovo je samo duža sintaksa ovog niže
    aggregate_failures do                                       #ova naredba će natjerat oba expect testa da se odvrte. Inače ako prvi fejla drugi se neće ni pokrenut
      expect(get "/articles").to route_to("articles#index")
      expect(get "/articles?page[number]=3").to(
        route_to("articles#index", page: {"number" => "3"})
      )
    end
  end
  it "routes to articles#show" do
    ["1", "2", "3", "4"].each do |i|
      expect(get "/articles/#{i}").to route_to("articles#show", "id" => "#{i}")
    end
  end
end
