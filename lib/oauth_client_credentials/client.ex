defmodule OauthClientCredentials.Client do

  def get url, token do
    response = HTTPoison.get url, [{"Authorization", token}]

    case response do
      {:ok, %HTTPoison.Response{body: body} } ->
        Poison.decode! body
      {:error, %HTTPoison.Error{reason: reason} } ->
        Poison.decode! %{error: "Error getting the resource: #{reason}"}
    end
  end

end
