defmodule KitchenSink.MatrixTest do
  @moduledoc false

  use ExUnit.Case
  alias KitchenSink.Matrix, as: M

  doctest KitchenSink.Matrix

  test "transpose" do
    expected = [[1, 4, 7],
                [2, 5, 8],
                [3, 6, 9]]

    input = [[1, 2, 3],
             [4, 5, 6],
             [7, 8, 9]]

    assert M.transpose(input) == expected
    assert M.transpose(expected) == input
  end
end
