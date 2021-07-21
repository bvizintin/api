require 'rails_helper'

RSpec.describe AccessTokensController, type: :controller do
  describe "#create" do
    context "when invalid request" do
      let(:error) do
                    {
                      status: "401",
                      source: { "pointer": "/code" },
                      title:  "Invalid Authentication Code",
                      detail: "You must provide valid code to exchange it for token."
                    }
      end


      it "shoudld return 401 code" do
        post :create
        expect(response).to have_http_status(401)
      end

      it "should return proper error body" do
        post :create
        expect(json[:errors]).to include(error)
      end

    end

    context "when success request" do

      let(:user_data) do
        {
          login: "jwick",
          url: "http://example.com",
          avatar_url: "http://example.com/avatar",
          name: "John Wick"
        }
      end

      before do
        allow_any_instance_of(Octokit::Client).to receive(:exchange_code_for_token).and_return("validaccesstoken")   #kad god se poziva :exchange metoda na bilo kojem Octokit::Client instanci, nemoj pozivati stvarnu :exchange metodu nego samo vrati error object. Ovaj override koristimo jer ne želimo za TESTIRANJE za stvarno slati zahtjeve githubu, niti ovisiti o internet vezi
        allow_any_instance_of(Octokit::Client).to receive(:user).and_return(user_data)
      end


      it "should return 201 success" do
        post :create, params: {code: "valid_code"}
        expect(response).to have_http_status(:created)
      end

      it "should return proper json body" do
        
      end
    end
  end
end
