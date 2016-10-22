defmodule KitchenSink.MapTest do
  @moduledoc false

  use ExUnit.Case
  alias KitchenSink.Map

  doctest KitchenSink.Map

  test "make sure that Elixir.map functions are working as normal" do
    assert Map.merge(%{a: 1}, %{a: 2}) == %{a: 1}
  end

  test "empty list produce empty map" do
    assert Map.merge([]) == %{}
  end

  test "map with 1 element produces that element" do
    assert Map.merge([%{a: 1}]) == %{a: 1}
  end

  test "map with 2 element produces the merge of those 2 according to merge/2 rules" do
    assert Map.merge([%{a: 1}, %{b: 1}]) == %{a: 1, b: 1}
    assert Map.merge([%{a: 1}, %{a: 2}]) == %{a: 2}
  end

  test "map with 3 element produces the merge of those 3" do
    assert Map.merge([%{a: 1}, %{b: 1}, %{c: 1}]) == %{a: 1, b: 1, c: 1}
    assert Map.merge([%{a: 1}, %{b: 1}, %{a: 2}]) == %{a: 2, b: 1}
  end

  test "map with 2 element produces the deep_merge of those 2 according to merge/2 rules" do
    assert Map.deep_merge(%{a: 1}, %{b: 1}) == %{a: 1, b: 1}
    assert Map.deep_merge(%{a: 1}, %{a: 2}) == %{a: 2}
    assert Map.deep_merge(%{a: %{b: 1, c: 1}}, %{a: %{b: 2}}) == %{a: %{b: 2, c: 1}}
  end

  test "map with many elements produces the deep merge of those 3" do
    assert Map.deep_merge([%{a: 1}, %{b: 1}, %{c: 1}]) == %{a: 1, b: 1, c: 1}
    assert Map.deep_merge([%{a: 1}, %{b: 1}, %{a: 2}]) == %{a: 2, b: 1}
    assert Map.deep_merge(%{a: %{b: 1, c: 1}}, %{a: %{b: 2}}) == %{a: %{b: 2, c: 1}}
    assert Map.deep_merge([%{a: %{b: 1, c: 1}}, %{a: %{b: 2}}, %{d: 2}]) == %{a: %{b: 2, c: 1}, d: 2}
    assert Map.deep_merge([%{a: %{b: %{c: %{d: 1}}}}, %{a: %{z: 1}}]) == %{a: %{b: %{c: %{d: 1}}, z: 1}}
  end

  test "empty map rename produce empty map" do
    assert Map.rename_key(%{}, :a, :b) == %{}
    assert Map.rename_key(%{}, {:a, :b}) == %{}
    assert Map.rename_key(%{}, %{a: :b}) == %{}
    assert Map.rename_key(%{}, [a: :b]) == %{}
  end

  test "nil rename produce empty map" do
    assert Map.rename_key(nil, :a, :b) == %{}
    assert Map.rename_key(nil, {:a, :b}) == %{}
    assert Map.rename_key(nil, %{a: :b}) == %{}
    assert Map.rename_key(nil, [a: :b]) == %{}
  end

  test "rename top-level key in map to same name produces same map" do
    assert Map.rename_key(%{a: 1}, :a, :a) == %{a: 1}
    assert Map.rename_key(%{a: 1}, :b, :b) == %{a: 1}
    assert Map.rename_key(%{a: 1}, {:a, :a}) == %{a: 1}
    assert Map.rename_key(%{a: 1}, {:b, :b}) == %{a: 1}
    assert Map.rename_key(%{a: 1}, %{a: :a}) == %{a: 1}
    assert Map.rename_key(%{a: 1}, %{b: :b}) == %{a: 1}
    assert Map.rename_key(%{a: 1}, [a: :a]) == %{a: 1}
    assert Map.rename_key(%{a: 1}, [b: :b]) == %{a: 1}
  end

  test "rename top-level key in map that doesn't exist produces same map" do
    assert Map.rename_key(%{a: 1}, :b, :c) == %{a: 1}
    assert Map.rename_key(%{a: 1}, {:b, :c}) == %{a: 1}
    assert Map.rename_key(%{a: 1}, %{b: :c}) == %{a: 1}
    assert Map.rename_key(%{a: 1}, [b: :c]) == %{a: 1}
  end

  test "rename top-level key produce new map with new key" do
    assert Map.rename_key(%{a: 1}, :a, :b) == %{b: 1}
    assert Map.rename_key(%{a: 1}, {:a, :b}) == %{b: 1}
    assert Map.rename_key(%{a: 1}, %{a: :b}) == %{b: 1}
    assert Map.rename_key(%{a: 1}, [a: :b]) == %{b: 1}
  end

  defmodule TestMap do
    defstruct name: nil,
              age: 0
  end

  test "Clean struct" do
    user1 = %TestMap{name: "User 1"}
    expected = %{name: "User 1"}
    actual = Map.clean_struct(user1)
    assert actual == expected
  end

  test "Don't overwrite structs when default" do
    user1 = %TestMap{name: "User 1"}
    user2 = %TestMap{age: 21}
    expected = %TestMap{name: "User 1", age: 21}
    actual = Map.deep_merge(user1, user2)
    assert actual == expected
  end
end
