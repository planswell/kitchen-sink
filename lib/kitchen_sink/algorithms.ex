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
  @type binary_search_strategy :: (:midpoint | :interval)
  @type binary_search_result :: {:ok, binary_search_position} | :not_found

  @type binary_interval_search_position :: number
  @type binary_interval_search_fit_func :: (binary_interval_search_position, any -> :ok | :high | :low)
  @type binary_interval_search_result :: {:ok, binary_interval_search_position} | :not_found

  @doc """
  `binary_search` performs a binary search over a range.

  The binary search function requires a midpoint strategy to be specified. If no strategy
  is specified, it defaults to `:midpoint`

  ## Examples using the `:midpoint` strategy

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
      iex> Algorithms.binary_search(0, 3, search_names, "Tony", :midpoint)
      {:ok, 3}
      iex> Algorithms.binary_search(0, 3, search_names, "Phil", :midpoint)
      {:not_found, 2}

  It is *possible* to override the calculation of the midpoint for the binary
  search, and that is "...left as an exercise for the reader."

  ## Examples using the `:interval` strategy

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
      iex> {:ok, result} = Algorithms.binary_search(1, 100, solve, 0.0, :interval)
      iex> Float.round(result, 6)
      10.311285
  """
  @spec binary_search(
    binary_search_position, binary_search_position, binary_search_fit_func, any, binary_search_strategy
  ) :: binary_search_result
  def binary_search(range_start, range_finish, fit, target, strategy) when is_function(fit) do
    do_binary_search(range_start, range_finish, fit, target, strategy)
  end

  def binary_search(range_start, range_finish, fit, target) do
    binary_search(range_start, range_finish, fit, target, :midpoint)
  end

  defp do_binary_search(start, finish, fit, target, strategy) when finish < start do
    binary_search(finish, start, fit, target, strategy)
  end
  defp do_binary_search(position, position, fit, target, _), do: ok_or_not_found(position, fit, target)
  defp do_binary_search(start, finish, fit, target, :midpoint) do
    mid = binary_search_midpoint(start, finish)
    case fit.(mid, target) do
      :ok -> {:ok, mid}
      :high -> do_binary_search(bounded_increment(mid, finish), finish, fit, target, :midpoint)
      :low -> do_binary_search(start, bounded_decrement(mid, start), fit, target, :midpoint)
   end
  end
  defp do_binary_search(start, finish, fit, target, :interval) do
    mid = binary_search_interval(start, finish)
    case fit.(mid, target) do
      :ok -> {:ok, mid}
      :high -> do_binary_search(mid, finish, fit, target, :interval)
      :low -> do_binary_search(start, mid, fit, target, :interval)
    end
  end

  defp binary_search_midpoint(start, finish) do
    start + div(finish - start, 2)
  end

  defp binary_search_interval(start, finish) do
    start + (finish - start) / 2.0
  end

  defp bounded_increment(to_increment, bound) do
    min(to_increment + 1, bound)
  end

  defp bounded_decrement(to_decrement, bound) do
    max(to_decrement - 1, bound)
  end

  defp ok_or_not_found(n, fit, target) do
    case fit.(n, target) do
      :ok -> {:ok, n}
      _ -> {:not_found, n}
    end
  end
end
