defmodule OauthClientCredentials do

  @client_id "foo"
  @client_secret "bar"
  @auth_url "authurl.com/auth"
  @resource_url "site.com/res"

  def start from_date do
    token = get_token
    fetch_items token from_date
  end

  def get_token do 
    base_encoded = Base.encode64(@client_id <> ":" <> @client_secret)
    res = HTTPoison.post! @auth_url, "grant_type=client_credentials", 
      [{"Authorization", "Basic #{base_encoded}"}]
    res_decoded = Poison.decode! res.body
    ~s("Bearer #{res_decoded["access_token"]})
  end

  def fetch_items token, from_date do
    items = Poison.decode!( HTTPoison.get!(@resource_url, [{"Authorization", token}]).body )["items"]

    case items do
      [] ->
        :finished
      _ ->
        for item <- items do
          delete_item token, item["id"]
        end
        fetch_items token, from_date
  end

  def delete_item token item_id do
    case HTTPoison.delete! "#{@resource_url}/#{item_id}", [{"Authorization", token}] do
      %HTTPoison.Response{ body: body, status_code } ->
        IO.puts "#{status_code} deleted item #{item_id}"
      %HTTPoison.Error{ reason: reason } ->
        IO.puts "Error deleting item #{item_id}"
    end
  end

end
