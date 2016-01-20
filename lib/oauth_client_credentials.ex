defmodule OauthClientCredentials do

  def get_token %{ token_url: token_url,
                   client_id: id, client_secret: secret} do
    base_encoded = Base.encode64(id <> ":" <> secret)
    res = HTTPoison.post! token_url, "grant_type=cient_credentials",
      [{"Authorization", "Basic #{base_encoded}"},
       {"Content-Type", "application/x-www-form-urlencoded"}]
    res_decoded = Poison.decode! res.body
    "Bearer #{res_decoded["access_token"]}"
  end

end
