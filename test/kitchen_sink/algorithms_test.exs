defmodule KitchenSink.AlgorithmsTest do
  @moduledoc false

  use ExUnit.Case

  alias KitchenSink.Algorithms
  doctest Algorithms

  def look_for(desired_result) do
    fn(value_to_test) ->
      cond do
        value_to_test < desired_result -> :high
        value_to_test == desired_result -> :ok
        value_to_test > desired_result -> :low
      end
    end
  end

  test "Range with reversed endpoints" do
    assert {:ok, 3} == Algorithms.binary_search(5 .. 1, look_for(3))
  end

  test "Single element range with desired value" do
    assert {:ok, 2} == Algorithms.binary_search(2 .. 2, look_for(2))
  end

  test "Single element range without desired value" do
    assert :not_found == Algorithms.binary_search(2 .. 2, look_for(3))
  end

  test "Interval with reversed endpoints" do
    assert {:ok, 3.5} == Algorithms.binary_search(5, 1, look_for(3.5))
  end
end
