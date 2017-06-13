defmodule KitchenSink.Algorithms do
  @moduledoc """
  This is a collection of algorithms.

  ## The binary search `fit` function

  The search is controlled by the `fit` function which is passed the value to
  test and returns `:ok` if the value is good enough, `:high` if the next
  value to test should be higher, or `:low` if the next value should be
  lower.
  """

  @type fit_func :: (number -> :ok | :high | :low)
  @type mid_func :: (number, number -> number)
  @type binary_search_result :: {:ok, number} | :not_found

  @doc """
  `binary_search` performs a binary search over a `Range`. The
  range's start should be less than or equal to the finish, if not
  then they are swapped.

  ## Examples

      iex> look_for = fn(desired_result) ->
      ...>   fn(value_to_test) ->
      ...>     cond do
      ...>       value_to_test < desired_result -> :high
      ...>       value_to_test == desired_result -> :ok
      ...>       value_to_test > desired_result -> :low
      ...>     end
      ...>   end
      ...> end
      iex>
      iex> Algorithms.binary_search(1 .. 10, look_for.(7))
      {:ok, 7}
      iex> Algorithms.binary_search(1 .. 10, look_for.(17))
      :not_found
      iex> Algorithms.binary_search(1 .. 10, look_for.(7.5))
      :not_found
  """
  @spec binary_search(Range.t, fit_func) :: binary_search_result
  def binary_search(start .. finish, fit) when finish < start, do: binary_search(finish .. start, fit)
  def binary_search(%Range{} = range, fit), do: binary_search_range(range, fit)

  @doc """
  `binary_search` can also search in an interval. You must provide the start
  and finish values and a `fit` function.

  ## Examples

      iex> look_for = fn(desired_result) ->
      ...>   fn(value_to_test) ->
      ...>     cond do
      ...>       value_to_test < desired_result -> :high
      ...>       value_to_test == desired_result -> :ok
      ...>       value_to_test > desired_result -> :low
      ...>     end
      ...>   end
      ...> end
      iex>
      iex> Algorithms.binary_search(1, 10, look_for.(7.5))
      {:ok, 7.5}
  """

  @spec binary_search(number, number, fit_func) :: binary_search_result
  def binary_search(start, finish, fit) when is_number(start) and is_number(finish) do
    binary_search(start / 1, finish / 1, fit, &floating_mid/2)
  end

  @doc """
  You can provide a custom function for determining the mid point of a range
  if the arithmetic mid-point does not meet your needs.
  """
  @spec binary_search(number, number, fit_func, mid_func) :: binary_search_result
  def binary_search(start, finish, fit, calculate_mid) when finish < start do
    binary_search(finish, start, fit, calculate_mid)
  end
  def binary_search(x, x, fit, _), do: ok_or_not_found(x, fit)
  def binary_search(start, finish, fit, calculate_mid) do
    mid = calculate_mid.(start, finish)
    case fit.(mid) do
      :ok -> {:ok, mid}
      :high -> binary_search(mid, finish, fit, calculate_mid)
      :low -> binary_search(start, mid, fit, calculate_mid)
    end
  end

  defp binary_search_range(x .. x, fit), do: ok_or_not_found(x, fit)
  defp binary_search_range(start .. finish, fit) do
    mid = start + div(finish - start, 2)
    case fit.(mid) do
      :ok -> {:ok, mid}
      :high -> binary_search_range((mid + 1) .. finish, fit)
      :low -> binary_search_range(start .. (mid - 1), fit)
    end
  end

  defp floating_mid(range_start, range_finish) do
    range_start + (range_finish - range_start) / 2
  end

  defp ok_or_not_found(n, fit) do
    case fit.(n) do
      :ok -> {:ok, n}
      _ -> :not_found
    end
  end
end
