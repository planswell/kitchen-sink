defmodule KitchenSink.Integer do
  @moduledoc """
  this module is for Integer functions
  """

  @doc """
  Make sure that we get an integer either from an integer or string

  iex> ensure_integer("1")
  1
  iex> ensure_integer(2)
  2
  """
  def ensure_integer(i) when is_integer(i), do: i
  def ensure_integer(s) when is_binary(s), do: s |> String.trim() |> String.to_integer()
end
