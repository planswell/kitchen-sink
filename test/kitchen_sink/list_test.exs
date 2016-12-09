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
    assert L.index_on(input, :a, :b) == expected
  end

  test "pluck" do

    input = [%{a: 1}, %{a: 2}, %{a: 3}]
    expected = [1, 2, 3]

    actual = L.pluck(input, :a)

    assert expected == actual


    input = [%{b: 1}, %{a: 2}, %{a: 3}]
    expected = [nil, 2, 3]

    actual = L.pluck(input, :a)

    assert expected == actual


    input = []
    expected = []

    actual = L.pluck(input, :a)

    assert expected == actual
  end

  describe "index_by/2" do
    test "index by key"do
      expected = %{
        a: %{name: :a, other: 1},
        b: %{name: :b, other: 4}
      }

      input = [
        %{name: :a, other: 1},
        %{name: :b, other: 4}
      ]

      actual = L.index_by(input, :name)

      assert expected == actual
    end
  end
end
