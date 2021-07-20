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

    end
  end
end
