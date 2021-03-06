defmodule KitchenSink.Boolean do
  @moduledoc """
  this module is for Boolean functions
  """

  defp string_bool?("true"), do: true
  defp string_bool?("false"), do: false
  defp string_bool?("t"), do: true
  defp string_bool?("f"), do: false
  defp string_bool?("on"), do: true
  defp string_bool?("off"), do: false
  defp string_bool?("yes"), do: true
  defp string_bool?("no"), do: false
  defp string_bool?("y"), do: true
  defp string_bool?("n"), do: false
  defp string_bool?(_), do: :error

  @doc """
  Parse boolean either from string or integer, if it's not a boolean then it returns :error

      iex> parse("True")
      true
      iex> parse("Lie")
      :error
  """
  @spec parse(String.t() | integer) :: boolean | :error
  def parse(value) when is_binary(value) do
    value
    |> String.trim()
    |> String.downcase()
    |> string_bool?
  end

  def parse(value) when is_integer(value) do
    case value do
      1 -> true
      0 -> false
      _ -> :error
    end
  end
end
