defmodule KitchenSink.Math do

  @moduledoc """
  Math functions!
  """

  @typedoc """
  Some functions allow us to specify *something* to return in a case which would
  normally raise an error. This type identifies that.
  """
  @type error_return :: any

  @doc """
  Numerical division which allows a specified return for "divide by zero."

      iex> div(1, 2, :oops)
      0.5
      iex> div(1, 0, :oops)
      :oops
  """
  @spec div(number, number, error_return) :: number | error_return
  def div(_numerator, 0, div_by_zero), do: div_by_zero
  def div(_numerator, 0.0, div_by_zero), do: div_by_zero
  def div(numerator, denominator, _div_by_zero), do: numerator / denominator

  defdelegate ceil(number, significance), to: __MODULE__, as: :round_up_to_multiple
  defdelegate floor(number, significance), to: __MODULE__, as: :round_down_to_multiple

  @doc """
  Round down to the nearest multiple of significance.

  ## Parameters

    - number: The number you wish to have rounded.
    - significance: The multiple to which you would like to round.
                    Must not be 0.

  ## Examples:

      iex> round_down_to_multiple(31, 5)
      30

      iex> round_down_to_multiple(29.49, 10)
      20
  """
  @spec round_down_to_multiple(number, number) :: number | no_return
  def round_down_to_multiple(_, 0) do
    raise ArgumentError, message: "Significance multiple cannot be zero."
  end
  def round_down_to_multiple(number, significance) when is_integer(significance) do
    trunc(Float.floor(number / significance) * significance)
  end

  @doc """
  Always round up to the nearest multiple of significance.

  ## Parameters

    - number: The number you wish to have rounded.
    - significance: The multiple to which you would like to round.
                    Must not be 0.

  ## Examples:

      iex> round_up_to_multiple(31, 5)
      35

      iex> round_up_to_multiple(29.49, 10)
      30
  """
  @spec round_up_to_multiple(number, number) :: number | no_return
  def round_up_to_multiple(_, 0) do
    raise ArgumentError, message: "Significance multiple cannot be zero."
  end
  def round_up_to_multiple(number, significance) when is_integer(significance) do
    trunc(Float.ceil(number / significance) * significance)
  end
end
