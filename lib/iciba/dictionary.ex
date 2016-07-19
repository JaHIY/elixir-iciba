defmodule ICIBA.Dictionary do
  @base_uri "http://dict-co.iciba.com"
  @dict_path "/api/dictionary.php"

  defp handle_response(%HTTPotion.Response{status_code: 200, body: body}) do
    Poison.decode(body)
  end

  defp handle_response(res) do
    {:error, res}
  end

  defp check_param(param) do
    case param do
      nil -> raise {:error, "api_key is not defined."}
      _   -> param
    end
  end

  def look_up(word) do
    query = [
      type: :json,
      key: ICIBA.Config.get(:api_key) |> check_param,
      w: word,
    ]

    dict_uri = %URI{
      URI.parse(@base_uri) |
      path: @dict_path,
      query: URI.encode_query(query)
    }

    dict_uri |> HTTPotion.get
             |> handle_response
  end
end
