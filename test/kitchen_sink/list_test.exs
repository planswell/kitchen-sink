defmodule KitchenSink.ListTest do
  @moduledoc false

  use ExUnit.Case
  alias KitchenSink.List, as: L

  doctest KitchenSink.List, import: true

  test "pluck" do
    input = [%{a: 1}, %{a: 2}, %{a: 3}]
    expected = [1, 2, 3]

    actual = L.pluck(input, :a)

    assert expected == actual

    input = []
    expected = []

    actual = L.pluck(input, :a)

    assert expected == actual
  end
end
