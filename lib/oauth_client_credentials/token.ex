defmodule OauthClientCredentials.Token do

  BEARER_TOKEN = "Bearer"

  def get do
    base_encoded = Base.encode64(id <> ":" <> secret)

    response = HTTPoison.post token_url, "grant_type=cient_credentials",
      [{"Authorization", "Basic #{base_encoded}"},
       {"Content-Type", "application/x-www-form-urlencoded"}]

    res_decoded = case response do
      {:ok, %HTTPoison.Response{body: body} } ->
        res_decoded = Poison.decode! res.body
      {:error, %HTTPoison.Error{reason: reason} } ->
        res_decoded = Poison.decode! %{error: "Error fetching the token"}
    end

    "#{BEARER_TOKEN} #{res_decoded["access_token"]}"
  end


end
