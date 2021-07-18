class UserAuthenticator
  class AuthenticationError < StandardError; end
  attr_reader :user

  def initialize(code)
     @code = code
  end

  def perform
    client = Octokit::Client.new(
      client_id: ENV['GITHUB_CLIENT_ID'],
      client_secret: ENV['GITHUB_CLIENT_SECRET']
    )
    res = client.exchange_code_for_token(code)   # ova exchange metoda šalje naš kod githubu, koji vraća access token
    if res.error.present?
      raise AuthenticationError
    else

    end
  end

  private
  attr_reader :code

end
