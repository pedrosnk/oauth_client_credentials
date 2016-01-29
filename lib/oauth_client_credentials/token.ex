defmodule OauthClientCredentials.Token do

  @bearer_token "Bearer"

  def get client_id, client_secret, token_url do
    base_encoded = Base.encode64(client_id <> ":" <> client_secret)

    response = HTTPoison.post token_url, "grant_type=cient_credentials",
      [{"Authorization", "Basic #{base_encoded}"},
       {"Content-Type", "application/x-www-form-urlencoded"}]

    res_decoded = case response do
      {:ok, %HTTPoison.Response{body: body} } ->
        Poison.decode! body
      {:error, %HTTPoison.Error{reason: reason} } ->
        Poison.decode! %{error: "Error fetching the token: #{reason}" }
    end

    "#{@bearer_token} #{res_decoded["access_token"]}"
  end


end
