defmodule ICIBA.ConfigTest do
  use ExUnit.Case
  doctest ICIBA.Config

  setup do
    ICIBA.Config.delete(:abcd)
  end

  test "get config" do
    assert ICIBA.Config.get(:abcd) == nil
  end

  test "get config with default" do
    assert ICIBA.Config.get(:abcd, "qwer") == "qwer"
  end

  test "put config" do
    ICIBA.Config.put(:abcd, "asdf")
    assert ICIBA.Config.get(:abcd) == "asdf"
  end
end

