require 'rails_helper'

RSpec.describe User, type: :model do
  describe "#validations" do
    it "should have valid factory" do
      user = build :user                  # FactoryBot kreira usera, isto ko za article
      expect(user).to be_valid
    end

    it "should validate presence of attributes" do
      user = build :user, login: nil, provider: nil
      aggregate_failures do
        expect(user).not_to be_valid
        expect(user.errors.messages[:login]).to include("can't be blank")
        expect(user.errors.messages[:provider]).to include("can't be blank")
      end
    end

    it "should validate the uniqueness of login name" do
      user1 = create :user, login: "dudli"   #prvi je .create, jer moramo ga pohraniti u bazu
      user2 = build :user, login: "dudli"    #drugi je dosta samo .build (to je bez spremanja) jer znamo da neće valjati
      expect(user2).not_to be_valid
      user2.login = "dudli2"
      expect(user2).to be_valid
    end
  end
end
