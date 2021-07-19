require "rails_helper"

describe UserAuthenticator do
  describe "#perform instance method" do
    let(:authenticator) {described_class.new("neki-kod")}      #ovo se poziva prije svakog example-a u kojemu se koristi.

    context "when code is invalid" do
      let(:error) { double("Sawyer::Resource", error: "bad_verification_code")}  #Sawyer je samo posebna vrsta Hash objekta koju Octokit vraća kada ima invalid verification kod

      before do
        allow_any_instance_of(Octokit::Client).to receive(:exchange_code_for_token).and_return(error)   #kad god se poziva :exchange metoda na bilo kojem Octokit::Client instanci, nemoj pozivati stvarnu :exchange metodu nego samo vrati error object. Ovaj override koristimo jer ne želimo za TESTIRANJE za stvarno slati zahtjeve githubu, niti ovisiti o internet vezi
      end

      it "should raise an error" do
        expect {authenticator.perform}.to raise_error(UserAuthenticator::AuthenticationError)   #pazi na {}. Postoji expect() i expect{}
        expect(authenticator.user).to be_nil
      end
    end

    context "when code is valid" do
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
      it "should save the new user" do
        expect{authenticator.perform}.to change{ User.count }.by(1)
      end

      it "should reuse already registered user" do
        user = create :user, user_data
        expect{authenticator.perform}.not_to change{User.count}
        expect(authenticator.user).to eq(user)
      end

      it "should create and set user's token" do
        expect{authenticator.perform}.to change{AccessToken.count}.by(1)
        expect(authenticator.access_token).to be_present
      end

    end
  end
end
