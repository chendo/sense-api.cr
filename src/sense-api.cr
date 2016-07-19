require "./sense-api/*"
require "cossack"
require "http"

class Sense::API
  API_ROOT = "https://api.hello.is/"

  struct OAuthTokenResponse
    JSON.mapping({
      name: String,
      token_type: String,
      expires_in: UInt64,
      account_id: String,
      access_token: String,
      refresh_token: String,
    })
  end

  def initialize(email : String, password : String)
    client = Cossack::Client.new(API_ROOT) do |client|
      client.headers["X-Client-Version"] = "1.4.4.4"
      client.headers["Content-Type"] = "application/x-www-form-urlencoded"
      client.headers["User-Agent"] = "Sense/1.4.4.4 Platform/iOS OS/9.3.2"
    end

    body = HTTP::Params.build do |form|
      form.add "client_id", "cbaf8aaf-609a-46f8-98d9-292d5376a6b7"
      form.add "grant_type", "password"
      form.add "username", email
      form.add "password", password
    end
    resp = client.post("/v1/oauth2/token", body)
    token_response = OAuthTokenResponse.from_json(resp.body)
    initialize(access_token: token_response.access_token)
  end

  def initialize(access_token : String)
    @client = Cossack::Client.new(API_ROOT) do |client|
      client.headers["Authorization"] = "Bearer #{access_token}"
      client.headers["X-Client-Version"] = "1.4.4.4"
      client.headers["User-Agent"] = "Sense/1.4.4.4 Platform/iOS OS/9.3.2"
    end
  end

  include Timeline
  include Sensors
end
