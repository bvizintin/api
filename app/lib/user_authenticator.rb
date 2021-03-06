class UserAuthenticator
  class AuthenticationError < StandardError; end
  attr_reader :user, :access_token

  def initialize(code)
     @code = code
  end

  def perform

    raise AuthenticationError if code.blank?
    raise AuthenticationError if token.try(:error).present?


    prepare_user
    @access_token =  if user.access_token.present?
                        user.access_token
                      else
                        user.create_access_token
                      end
    
  end

  private
  attr_reader :code

  def client
     @client ||= Octokit::Client.new(
      client_id: ENV['GITHUB_CLIENT_ID'],
      client_secret: ENV['GITHUB_CLIENT_SECRET']
    )
  end

  def token
    @token ||= client.exchange_code_for_token(code)   # ova exchange metoda šalje naš kod githubu, koji vraća access token
  end

  def user_data
    @user_data ||= Octokit::Client.new( access_token: token).user.to_h.slice(:login, :avatar_url, :url, :name)            # .user metoda kada se poziva na Octokit objektu vraća sve moguće podatke o Useru u obliku Sayer objekta. .to_h ga pretvara u korisni hash iz kojeg slajsamo samo kaj nam treba
  end

  def prepare_user
    if User.exists?(login: user_data[:login])
      @user = User.find_by(login: user_data[:login])
    else
      @user = User.create(user_data.merge(provider: "github"))
    end
  end

end
