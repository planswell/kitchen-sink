defmodule KitchenSink.MapTest do
  @moduledoc false

  use ExUnit.Case
  alias KitchenSink.Map, as: KMap

  doctest KitchenSink.Map

  test "empty list produce empty map" do
    assert KMap.merge([]) == %{}
  end

  test "map with 1 element produces that element" do
    assert KMap.merge([%{a: 1}]) == %{a: 1}
  end

  test "map with 2 element produces the merge of those 2 according to merge/2 rules" do
    assert KMap.merge([%{a: 1}, %{b: 1}]) == %{a: 1, b: 1}
    assert KMap.merge([%{a: 1}, %{a: 2}]) == %{a: 2}
  end

  test "map with 3 element produces the merge of those 3" do
    assert KMap.merge([%{a: 1}, %{b: 1}, %{c: 1}]) == %{a: 1, b: 1, c: 1}
    assert KMap.merge([%{a: 1}, %{b: 1}, %{a: 2}]) == %{a: 2, b: 1}
  end

  test "map with 2 element produces the deep_merge of those 2 according to merge/2 rules" do
    assert KMap.deep_merge(%{a: 1}, %{b: 1}) == %{a: 1, b: 1}
    assert KMap.deep_merge(%{a: 1}, %{a: 2}) == %{a: 2}
    assert KMap.deep_merge(%{a: %{b: 1, c: 1}}, %{a: %{b: 2}}) == %{a: %{b: 2, c: 1}}
  end

  test "map with many elements produces the deep merge of those 3" do
    assert KMap.deep_merge_list([%{a: 1}, %{b: 1}, %{c: 1}]) == %{a: 1, b: 1, c: 1}
    assert KMap.deep_merge_list([%{a: 1}, %{b: 1}, %{a: 2}]) == %{a: 2, b: 1}
    assert KMap.deep_merge(%{a: %{b: 1, c: 1}}, %{a: %{b: 2}}) == %{a: %{b: 2, c: 1}}
    assert KMap.deep_merge_list([%{a: %{b: 1, c: 1}}, %{a: %{b: 2}}, %{d: 2}]) == %{a: %{b: 2, c: 1}, d: 2}
    assert KMap.deep_merge_list([%{a: %{b: %{c: %{d: 1}}}}, %{a: %{z: 1}}]) == %{a: %{b: %{c: %{d: 1}}, z: 1}}
  end

  test "map with list" do
    assert KMap.deep_merge(%{a: [%{b: 1}, %{c: 2}]}, %{a: [%{b: 3}, %{c: 4}]}, merge_lists: true) ==
      %{a: [%{b: 3}, %{c: 4}]}

    assert KMap.deep_merge(%{a: [%{b: 1}, %{c: 2}]}, %{a: [%{d: 3}, %{e: 4}]}, merge_lists: true) ==
      %{a: [%{b: 1, d: 3}, %{c: 2, e: 4}]}

    assert KMap.deep_merge(%{a: [%{b: 1}, %{c: 2}, %{f: 5}]}, %{a: [%{d: 3}, %{e: 4}]}, merge_lists: true) ==
      %{a: [%{b: 1, d: 3}, %{c: 2, e: 4}, %{f: 5}]}

    assert KMap.deep_merge(%{a: [%{b: 1}, %{c: 2}]}, %{a: [%{d: 3}, %{e: 4}, %{f: 5}]}, merge_lists: true) ==
      %{a: [%{b: 1, d: 3}, %{c: 2, e: 4}, %{f: 5}]}

    assert KMap.deep_merge(%{a: []}, %{a: [%{d: 3}, %{e: 4}, %{f: 5}]}, merge_lists: true) ==
      %{a: [%{d: 3}, %{e: 4}, %{f: 5}]}

    assert KMap.deep_merge(%{a: [%{b: 1}, %{c: 2}]}, %{a: []}, merge_lists: true) ==
      %{a: [%{b: 1}, %{c: 2}]}

    assert KMap.deep_merge(%{a: nil}, %{a: [%{d: 3}, %{e: 4}, %{f: 5}]}, merge_lists: true) ==
      %{a: [%{d: 3}, %{e: 4}, %{f: 5}]}

    assert KMap.deep_merge(%{a: [%{b: 1}, %{c: 2}]}, %{a: nil}, merge_lists: true) ==
      %{a: nil}

    assert KMap.deep_merge(%{a: %{b: [1]}},%{a: %{b: [2]}}) == %{a: %{b: [2]}}
  end

  test "empty map rename produce empty map" do
    assert KMap.rename_key(%{}, :a, :b) == %{}
    assert KMap.rename_key(%{}, {:a, :b}) == %{}
    assert KMap.rename_key(%{}, %{a: :b}) == %{}
    assert KMap.rename_key(%{}, [a: :b]) == %{}
  end

  test "nil rename produce empty map" do
    assert KMap.rename_key(nil, :a, :b) == %{}
    assert KMap.rename_key(nil, {:a, :b}) == %{}
    assert KMap.rename_key(nil, %{a: :b}) == %{}
    assert KMap.rename_key(nil, [a: :b]) == %{}
  end

  test "rename top-level key in map to same name produces same map" do
    assert KMap.rename_key(%{a: 1}, :a, :a) == %{a: 1}
    assert KMap.rename_key(%{a: 1}, :b, :b) == %{a: 1}
    assert KMap.rename_key(%{a: 1}, {:a, :a}) == %{a: 1}
    assert KMap.rename_key(%{a: 1}, {:b, :b}) == %{a: 1}
    assert KMap.rename_key(%{a: 1}, %{a: :a}) == %{a: 1}
    assert KMap.rename_key(%{a: 1}, %{b: :b}) == %{a: 1}
    assert KMap.rename_key(%{a: 1}, [a: :a]) == %{a: 1}
    assert KMap.rename_key(%{a: 1}, [b: :b]) == %{a: 1}
  end

  test "rename top-level key in map that doesn't exist produces same map" do
    assert KMap.rename_key(%{a: 1}, :b, :c) == %{a: 1}
    assert KMap.rename_key(%{a: 1}, {:b, :c}) == %{a: 1}
    assert KMap.rename_key(%{a: 1}, %{b: :c}) == %{a: 1}
    assert KMap.rename_key(%{a: 1}, [b: :c]) == %{a: 1}
  end

  test "rename top-level key produce new map with new key" do
    assert KMap.rename_key(%{a: 1}, :a, :b) == %{b: 1}
    assert KMap.rename_key(%{a: 1}, {:a, :b}) == %{b: 1}
    assert KMap.rename_key(%{a: 1}, %{a: :b}) == %{b: 1}
    assert KMap.rename_key(%{a: 1}, [a: :b]) == %{b: 1}
  end

  test "renaming a key that exists will overwrite it" do
    assert KMap.rename_key(%{a: 1, b: 2}, :a, :b, overwrite: true) == %{b: 1}
  end

  test "renaming a key that exists does nothing when overwrite: false" do
    assert KMap.rename_key(%{a: 1, b: 2}, :a, :b, overwrite: false) == %{a: 1, b: 2}
    assert KMap.rename_key(%{a: 1, b: 2}, :a, :b) == %{a: 1, b: 2}
  end

  test "new nested key" do
    expected = %{parent: %{child: %{conception: "kenbert this is for you"}}}
    actual = KMap.make_nested("kenbert this is for you", [:parent, :child, :conception])

    assert expected == actual
  end

  test "rename many keys from strings to atoms" do
    expected = %{
      "not remapped" => 0,
      value: 1,
      another_value: 2,
      solo_parent: "divorced",
      parent: %{
        possible_bad_merge: "bad merge",
        child1: "baby",
        child2: %{conception: "before baby"}},
    }

    expected2 = Map.delete(expected, "not remapped")

    key_map = %{
      "Some Value" => :value,
      "Another Rent" => :another_value,
      "Parent" => [:solo_parent],
      "Parent Nested With Child" => [:parent, :child1],
      "Parent Nested With Nested Child" => [:parent, :child2, :conception],
      "Merge Test" => [:parent, :possible_bad_merge]
    }

    input = %{
      "not remapped" => 0,
      "Some Value" => 1,
      "Another Rent" => 2,
      "Parent" => "divorced",
      "Parent Nested With Child" => "baby",
      "Parent Nested With Nested Child" => "before baby",
      "Merge Test" => "bad merge",
    }

    assert KMap.remap_keys(input, key_map) == expected
    assert KMap.remap_keys(input, key_map, prune: true) == expected2
    assert KMap.remap_keys(%{a: 1}, %{}, prune: true) == %{}
  end

  defmodule TestMap do
    defstruct name: nil,
              age: 0
  end

  test "Clean struct" do
    user1 = %TestMap{name: "User 1"}
    expected = %{name: "User 1"}
    actual = KMap.clean_struct(user1)
    assert actual == expected
  end

  test "Don't overwrite structs when default" do
    user1 = %TestMap{name: "User 1"}
    user2 = %TestMap{age: 21}
    expected = %TestMap{name: "User 1", age: 21}
    actual = KMap.deep_merge(user1, user2)
    assert actual == expected
  end

  test "Don't pollute structs when trying to merge invalid keys" do
    user1 = %TestMap{name: "User 1"}
    user2 = %{
      name: "John Appleseed",
      address: "1 Infinite Loop, Cupertino, CA 95014, USA"
    }
    expected = %TestMap{name: "John Appleseed"}
    actual = KMap.deep_merge(user1, user2)
    assert actual == expected
  end

  test "transform_values" do

    expected = %{age: 32, gender: :Female, multiplier: 28.71 , smoker?: :Smoker, term: 75}
    input = %{age: 32, gender: "Female", multiplier: "28.71", smoker?: "Smoker", term: "75.0"}

    parsers = %{
      age: fn x -> x end,
      gender: &String.to_atom/1,
      multiplier: &String.to_float/1,
      smoker?: &String.to_atom/1,
      term: &String.to_float/1,
    }

    actual = KMap.transform_values(parsers).(input)
    assert actual == expected

    actual = KMap.transform_values(input, parsers)
    assert actual == expected
  end

  describe "Map.key_paths/1" do
    test "no nesting" do

      input = %{a: 1, c: 2, d: 3}
      expected = [[:a], [:c], [:d]]
      actual = KMap.key_paths(input)

      assert expected == actual
    end

    test "nesting" do
      input = %{a: %{b: %{c: 1}, c: 2}, d: 3}
      expected = [
        [:a, :b, :c],
        [:a, :c],
        [:d],
      ]
      actual = KMap.key_paths(input)
      assert expected == actual
    end

    test "non-enumerables in map" do
      input = %{c: ~D[2000-01-01]}

      expected = [[:c]]
      actual = KMap.key_paths(input)
      assert expected == actual

      input = %{a: %{b: %{c: ~D[2000-01-01]}}}

      expected = [[:a, :b, :c]]
      actual = KMap.key_paths(input)
      assert expected == actual
    end
    test "values that are empty maps" do
      assert %{key1: %{}} |> KMap.key_paths()
      == [[:key1]]

      assert %{key1: %{key1: %{}, key2: %{}}, key2: %{key1: %{}, key2: %{}}} |> KMap.key_paths()
      == [[:key1, :key1], [:key1, :key2], [:key2, :key1], [:key2, :key2]]
    end
  end

  test "trim" do
    input = %{}
    expected = %{}
    assert KMap.trim(input) == expected

    input = %{
      a: nil
    }
    expected = %{}
    assert KMap.trim(input) == expected

    input = %{
      a: %{
        b: nil
      }
    }
    expected = %{}
    assert KMap.trim(input) == expected

    input = %{
      a: %{
        b: nil,
        c: 5
      }
    }
    expected = %{a: %{c: 5}}
    assert KMap.trim(input) == expected

    input = %{
      a: %{
        b: 5
      }
    }
    expected = %{a: %{b: 5}}
    assert KMap.trim(input) == expected

    input = %{
      a: %{
        b: nil
      },
      c: %{
        d: 5
      }
    }
    expected = %{c: %{d: 5}}
    assert KMap.trim(input) == expected
  end

  test "trim works with Enumerable Structs" do
    input = %TestStructNested{
      field1: %TestStruct{},
      field2: %TestStruct{},
    }
    expected = %{}
    assert KMap.trim(input) == expected

    input = %TestStructNested{
      field1: %TestStruct{
        age: 0
      },
      field2: %TestStruct{},
    }
    expected = %{field1: %{age: 0}}
    assert KMap.trim(input) == expected
  end

  test "trim with specialized function for determining values to reject" do

    # we declare that -1 is the same as nil or the empty map in this case
    empty_val? = fn
      {_key, %{} = map} when map_size(map) == 0 -> true
      {_key, -1} -> true
      {_key, nil} -> true
      {_key, _} -> false
    end

    input = %{
      a: %{
        b: -1
      },
      c: %{
        d: 5
      }
    }
    expected = %{c: %{d: 5}}
    assert KMap.trim(input, empty_val?) == expected
  end
end
