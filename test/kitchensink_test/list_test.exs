defmodule KitchenSink.ListTest do
  @moduledoc false

  use ExUnit.Case
  alias KitchenSink.List, as: L

  doctest KitchenSink.List

  test "transpose" do
    expected = [[1, 4, 7],
                [2, 5, 8],
                [3, 6, 9]]

    input = [[1, 2, 3],
             [4, 5, 6],
             [7, 8, 9]]

    assert L.transpose(input) == expected
    assert L.transpose(expected) == input
  end
end
