defmodule KitchenSink.Algorithms do
  @moduledoc """
  This is a collection of algorithms.

  ## The binary search `fit` function

  The search is controlled by the `fit` function which is passed the value to
  test and returns `:ok` if the value is good enough, `:high` if the next
  value to test should be higher, or `:low` if the next value should be
  lower.
  """

  @type binary_search_position :: integer
  @type binary_search_fit_func :: (binary_search_position, any -> :ok | :high | :low)
  @type binary_search_mid_func :: (binary_search_position, binary_search_position -> binary_search_position)
  @type binary_search_result :: {:ok, binary_search_position} | :not_found

  @type binary_interval_search_position :: number
  @type binary_interval_search_fit_func :: (binary_interval_search_position, any -> :ok | :high | :low)
  @type binary_interval_search_result :: {:ok, binary_interval_search_position} | :not_found

  @doc """
  `binary_search` performs a binary search over a range.

  ## Examples

      iex> names = ~w(Adrian Bill Robert Tony) # Sorted!
      iex> search_names = fn(position, target) ->
      ...>   current = Enum.at(names, position)
      ...>   cond do
      ...>     current < target -> :high
      ...>     current == target -> :ok
      ...>     current > target -> :low
      ...>   end
      ...> end
      iex>
      iex> Algorithms.binary_search(0, 3, search_names, "Tony")
      {:ok, 3}
      iex> Algorithms.binary_search(0, 3, search_names, "Phil")
      {:not_found, 2}

  It is *possible* to override the calculation of the midpoint for the binary
  search, and that is "...left as an exercise for the reader."
  """
  @spec binary_search(
    binary_search_position, binary_search_position, binary_search_fit_func, any, binary_search_mid_func
  ) :: binary_search_result
  def binary_search(range_start, range_finish, fit, target, calculate_mid \\ &binary_search_midpoint/2) when is_integer(range_start) and is_integer(range_finish) and is_function(fit) and is_function(calculate_mid) do
    do_binary_search(range_start, range_finish, fit, target, calculate_mid)
  end

  defp do_binary_search(start, finish, fit, target, calculate_mid) when finish < start do
    binary_search(finish, start, fit, target, calculate_mid)
  end
  defp do_binary_search(position, position, fit, target, _), do: ok_or_not_found(position, fit, target)
  defp do_binary_search(start, finish, fit, target, calculate_mid) do
    mid = calculate_mid.(start, finish)
    case fit.(mid, target) do
      :ok -> {:ok, mid}
      :high -> do_binary_search((mid + 1), finish, fit, target, calculate_mid)
      :low -> do_binary_search(start, (mid - 1), fit, target, calculate_mid)
    end
  end

  defp binary_search_midpoint(start, finish) do
    start + div(finish - start, 2)
  end

  @doc """
  `binary_interval_search` can search in an interval.

  ## Examples

  To see where *y = 10 + x³* and *y = 1000 + x²* intersect

      iex> solve = fn(position, _) ->
      ...>   y1 = 10 + :math.pow(position, 3)
      ...>   y2 = 1000 + :math.pow(position, 2)
      ...>   difference = y1 - y2
      ...>
      ...>   epsilon = 0.0001
      ...>
      ...>   cond do
      ...>     abs(difference) < epsilon -> :ok
      ...>     difference > 0.0 -> :low
      ...>     difference < 0.0 -> :high
      ...>   end
      ...> end
      iex>
      iex> {:ok, result} = Algorithms.binary_interval_search(1, 100, solve, 0.0)
      iex> Float.round(result, 6)
      10.311285
  """

  @spec binary_interval_search(
    binary_interval_search_position, binary_interval_search_position, binary_interval_search_fit_func, any
  ) :: binary_interval_search_result
  def binary_interval_search(interval_start, interval_finish, fit, target \\ nil) when is_number(interval_start) and is_number(interval_finish) and is_function(fit) do
    do_binary_interval_search(interval_start / 1, interval_finish / 1, fit, target)
  end

  defp do_binary_interval_search(position, position, fit, target), do: ok_or_not_found(position, fit, target)
  defp do_binary_interval_search(start, finish, fit, target) when start > finish do
    binary_interval_search(finish, start, fit, target)
  end
  defp do_binary_interval_search(start, finish, fit, target) do
    mid = start + (finish - start) / 2.0
    case fit.(mid, target) do
      :ok -> {:ok, mid}
      :high -> do_binary_interval_search(mid, finish, fit, target)
      :low -> do_binary_interval_search(start, mid, fit, target)
    end
  end

  defp ok_or_not_found(n, fit, target) do
    case fit.(n, target) do
      :ok -> {:ok, n}
      _ -> {:not_found, n}
    end
  end
end
