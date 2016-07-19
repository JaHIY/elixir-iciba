defmodule ICIBA.Config do

  def delete(key, opts \\ []) do
    Application.delete_env(:iciba, key, opts)
  end

  def get(key, default \\ nil) do
    Application.get_env(:iciba, key, default)
  end

  def put(key, value, opts \\ []) do
    Application.put_env(:iciba, key, value, opts)
  end

end
