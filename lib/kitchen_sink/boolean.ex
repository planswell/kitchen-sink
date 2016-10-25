defmodule KitchenSink.Boolean do

  @moduledoc """
  this module is for Boolean functions
  """

  @doc """
  Parse boolean either from string or integer, if it's not a boolean then it returns :error
  """
  def parse(st) when is_binary(st) do
    String.downcase(st)
    |> case do
      "true" -> true
      "false" -> false
      "t" -> true
      "f" -> false
      "on" -> true
      "off" -> false
      "yes" -> true
      "no" -> false
      "y" -> true
      "n" -> false
      _ -> :error
    end
  end
  def parse(i) when is_integer(i) do
    case i do
      1 -> true
      0 -> false
      _ -> :error
    end
  end
end
