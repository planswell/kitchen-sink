defmodule KitchenSink.FunctionTest do
  @moduledoc false

  use ExUnit.Case
  alias KitchenSink.Function, as: F

  doctest KitchenSink.Function

  test "identiy" do
    assert F.identity(1) == 1
    assert F.identity(%{a: 1}) == %{a: 1}
  end

  test "compose" do
    double = fn x -> x * 2 end
    triple = fn x -> x * 3 end
    square = fn x -> x * x end

    assert F.compose([square, double, triple]).(3) ==
             (3 * 3 * 2) |> :math.pow(2)
  end

  test "pipe" do
    double = fn x -> x * 2 end
    triple = fn x -> x * 3 end
    square = fn x -> x * x end

    assert F.pipe([square, double, triple]).(3) == 3 * 3 * 2 * 3
  end

  test "juxt" do
    expected = [[2, 3, 1], [4, 6, 4], [6, 9, 9]]

    double = fn x -> x * 2 end
    triple = fn x -> x * 3 end
    square = fn x -> x * x end

    assert F.juxt([double, triple, square]).([1, 2, 3]) == expected
  end
end
