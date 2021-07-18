require "rails_helper"

describe UserAuthenticator do
  describe "#perform instance method" do
    let(:authenticator) {described_class.new("neki-kod")}      #ovo se poziva prije svakog example-a u kojemu se koristi.

    context "when code is invalid" do
      before do
        allow_any_instance_of(Octokit::CLient).to receive(:exchange_code_for_token).and_return(error)   #kad god se poziva :exchange metoda na bilo kojem Octokit::Client instanci, nemoj pozivati stvarnu :exchange metodu nego samo vrati error object. Ovaj override koristimo jer ne želimo za TESTIRANJE za stvarno slati zahtjeve githubu, niti ovisiti o internet vezi
      end
      
      it "should raise an error" do
        expect {authenticator.perform}.to raise_error(UserAuthenticator::AuthenticationError)   #pazi na {}. Postoji expect() i expect{}
        expect(authenticator.user).to be_nil
      end
    end

    context "when code is valid" do
      it "should save the new user" do
        expect(authenticator.perform).to change{ User.count }.by(1)
      end
    end
  end
end
