defmodule KitchenSink.Math do

  @moduledoc """
  Math functions!
  """

  @doc """
  handles divide by zero gracefully.

  third argument is what to return when you divide by zero.
  """
  def div(_numerator, 0, div_by_zero), do: div_by_zero
  def div(_numerator, 0.0, div_by_zero), do: div_by_zero
  def div(numerator, denominator, _div_by_zero), do: numerator / denominator

  @doc """
  Always round up to the nearest multiple of significance

  ## Example:

  iex> ceil(31, 5)
  35
  """
  def ceil(number, significance) when is_integer(number) and is_integer(significance) do
    trunc(Float.ceil(number / significance) * significance)
  end
end
