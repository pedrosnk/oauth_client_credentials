defmodule OauthClientCredentialsTest do
  use ExUnit.Case
  use Plug.Test
  doctest OauthClientCredentials

  setup do
    bypass = Bypass.open
    {:ok, bypass: bypass}
  end

  test "Make Request for the server asking for token", %{bypass: bypass} do

    url = "http://localhost:#{bypass.port}"
    Bypass.expect bypass, fn conn ->
      assert "POST" == conn.method
      conn
        |> Plug.Conn.resp(200, ~s({"access_token": "abcdef=="}))
    end

    token = OauthClientCredentials.get_token %{token_url: url,
      client_id: "123", client_secret: "456"}

    assert token == "Bearer abcdef=="
  end
end
