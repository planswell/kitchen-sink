defmodule KitchenSink.StructEnumTest do
  @moduledoc false

  use ExUnit.Case

  test "count for empty struct should be zero" do
    assert Enum.count(%TestStruct{}) == 0
  end

  test "check if map works" do
    expected = [30, "Test User"]

    actual = Enum.map(%TestStruct{name: "Test User", age: 30}, fn {_, v} -> v end)

    assert expected == actual
  end

  test "check if into works" do
    expected = %TestStruct{name: "Test User", age: 30}

    actual = Enum.into(%{name: "Test User", age: 30}, %TestStruct{})

    assert expected == actual
  end
end
