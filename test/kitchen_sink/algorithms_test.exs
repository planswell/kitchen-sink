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
    assert :not_found == Algorithms.binary_search(2, 2, &find_target/2, 3)
  end

  test "Interval with reversed endpoints" do
    assert {:ok, 3.5} == Algorithms.binary_interval_search(5, 1, &find_target/2, 3.5)
  end
end
