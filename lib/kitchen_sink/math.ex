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
  Always round up to the nearest multiple of significance.

  ## Parameters

    - number: The number you wish to have rounded.
    - significance: The multiple to which you would like to round.
                    Must not be 0.

  ## Example:

  iex> round_up_to_multiple(31, 5)
  35

  iex> round_up_to_multiple(29.49, 10)
  30
  """
  def round_up_to_multiple(_, 0) do
    raise ArgumentError, message: "Significance multiple cannot be zero."
  end
  def round_up_to_multiple(number, significance) when is_integer(significance) do
    trunc(Float.ceil(number / significance) * significance)
  end
end
