defmodule KitchenSink.ListTest do
  @moduledoc false

  use ExUnit.Case
  alias KitchenSink.List, as: L

  doctest KitchenSink.List

  test "index_on" do
    expected = %{
      %{a: 1} => 1,
      %{a: 2} => 2,
      %{a: 3} => 3
    }

    input = [
      %{a: 1, b: 1},
      %{a: 2, b: 2},
      %{a: 3, b: 3}
    ]

    assert L.index_on(input, [:a], :b) == expected
  end
end
