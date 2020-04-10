defmodule KitchenSink.MiscTest do
  @moduledoc false

  use ExUnit.Case
  import KitchenSink.Misc

  doctest KitchenSink.Misc, import: true

  test "curried nth function is put into the module and works as expected" do
    tuple = {1, 2, 3, 4, 5}
    list = [1, 2, 3, 4, 5]
    map = %{a: 1, b: 2, c: 3, d: 4, e: 5}

    assert nth(0).(tuple) == 1
    assert nth(0).(list) == 1
    assert nth(0).(map) == %{a: 1}
    assert elem(tuple, 0) == 1
    assert get_in(list, [Access.at(0)]) == 1
    assert get_in(tuple, [Access.elem(0)]) == 1

    assert get_in(Map.to_list(map), [Access.at(0)]) |> List.wrap() |> Map.new() ==
             %{a: 1}

    assert map |> Enum.take(1) |> List.wrap() |> Map.new() == %{a: 1}
    assert map |> Stream.take(1) |> Enum.to_list() |> Map.new() == %{a: 1}
  end

  test "named nth functions is put into the module and works as expected" do
    tuple = {1, 2, 3, 4, 5}
    list = [1, 2, 3, 4, 5]
    map = %{a: 1, b: 2, c: 3, d: 4, e: 5}

    assert first(tuple) == 1
    assert first(list) == 1
    assert first(map) == %{a: 1}

    assert second(tuple) == 2
    assert second(list) == 2
    assert second(map) == %{b: 2}

    assert third(tuple) == 3
    assert third(list) == 3
    assert third(map) == %{c: 3}

    assert fourth(tuple) == 4
    assert fourth(list) == 4
    assert fourth(map) == %{d: 4}
  end
end
