defmodule ICIBA.DictionaryTest do
  use ExUnit.Case
  doctest ICIBA.Dictionary

  setup_all do
    Application.put_env(:iciba, :api_key, "30CBA9DDD34B16DB669A9B214C941F14")
  end

  test "look up word" do
    {:ok, %{"word_name" => name}} = ICIBA.Dictionary.look_up("apple")

    assert name == "apple"
  end
end
