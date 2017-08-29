defmodule KitchenSink.AlgorithmsTest do
  @moduledoc false

  use ExUnit.Case

  alias KitchenSink.Algorithms
  doctest Algorithms

  def find_target(pos, desired_result) do
    cond do
      pos < desired_result -> :high
      pos == desired_result -> :ok
      pos > desired_result -> :low
    end
  end

  test "Range with reversed endpoints" do
    assert {:ok, 3} == Algorithms.binary_search(5, 1, &find_target/2, 3)
  end

  test "Single element range with desired value" do
    assert {:ok, 2} == Algorithms.binary_search(2, 2, &find_target/2, 2)
  end

  test "Single element range without desired value" do
    assert {:not_found, 2} == Algorithms.binary_search(2, 2, &find_target/2, 3)
  end

  test "Range respects lower bound" do
    assert {:not_found, 31} == Algorithms.binary_search(31, 80, fn _, _ -> :low end, 3)
  end

  test "Random 0-straddled range with random target" do
    {lower, upper} = random_integer_range(:straddled, 1000)
    to_find = lower + :rand.uniform(1000)
    assert {:ok, to_find} == Algorithms.binary_search(lower, upper, &find_target/2, to_find)
  end

  test "Range respects positive randomised lower bound" do
    {lower, upper} = random_integer_range(:positive, 100)
    assert {:not_found, lower} == Algorithms.binary_search(lower, upper, fn _, _ -> :low end, 3)
  end

  test "Range respects negative randomised lower bound" do
    {lower, upper} = random_integer_range(:negative, 100)
    assert {:not_found, lower} == Algorithms.binary_search(lower, upper, fn _, _ -> :low end, 3)
  end

  test "Range respects upper bound" do
    assert {:not_found, 80} == Algorithms.binary_search(34, 80, fn _, _ -> :high end, 3)
  end

  test "Range respects positive randomised upper bound" do
    {lower, upper} = random_integer_range(:positive, 100)
    assert {:not_found, upper} == Algorithms.binary_search(lower, upper, fn _, _ -> :high end, 3)
  end

  test "Range respects extreme randomised upper bound" do
    {lower, upper} = random_integer_range(:negative, 100)
    assert {:not_found, upper} == Algorithms.binary_search(lower, upper, fn _, _ -> :high end, 3)
  end

  test "Interval with reversed endpoints" do
    assert {:ok, 3.5} == Algorithms.binary_search(5, 1, &find_target/2, 3.5, :interval)
  end

  # FIXME: Maybe make a Random module for these to live in?
  # Specify a range of `range_size` numbers that are all positive
  defp random_integer_range(:positive, range_size) when range_size > 1 do
    lower_bound = :rand.uniform(1000)
    upper_bound = lower_bound + range_size - 1

    {lower_bound, upper_bound}
  end
  # Specify a range of `range_size` numbers that are all negative
  defp random_integer_range(:negative, range_size) when range_size > 1 do
    upper_bound = 0 - :rand.uniform(1000)
    lower_bound = upper_bound - range_size - 1

    {lower_bound, upper_bound}
  end
  # Specify a range of `range_size` numbers that range from negative to positive
  defp random_integer_range(:straddled, range_size) when range_size > 2 do
    over_random = range_size / 2 |> round()

    upper_bound = :rand.uniform(over_random)
    lower_bound = upper_bound - range_size + 1

    {lower_bound, upper_bound}
  end
end
