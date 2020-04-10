defmodule KitchenSink.MapTest.TransformTest do
  @moduledoc false

  use ExUnit.Case
  alias KitchenSink.Map, as: KMap

  setup do
    %{
      expected: %{
        new_age: 32,
        gender: :Female,
        rate: %{inner_rate: 28.71},
        smoker!: :Smoker,
        term: 75
      },
      input: %{
        age: 32,
        gender: "Female",
        multiplier: "28.71",
        smoker?: "Smoker",
        term: "75.0"
      },
      t_map: %{
        age: {[:new_age], fn x -> x end},
        gender: {:gender, &String.to_atom/1},
        multiplier: {[:rate, :inner_rate], &String.to_float/1},
        smoker?: {:smoker!, &String.to_atom/1},
        term: {&String.to_float/1}
      }
    }
  end

  test "transform/1 returns a tranformation function", %{
    expected: expected,
    input: input,
    t_map: t_map
  } do
    actual = KMap.transform(t_map).(input)
    assert actual == expected
  end

  test "transform/2 transform input using t_map", %{
    expected: expected,
    input: input,
    t_map: t_map
  } do
    actual = KMap.transform(input, t_map)
    assert actual == expected
  end

  test "transform/3 :prune option prunes keys not defined in tranform",
       %{expected: expected, input: input, t_map: t_map} do
    fat_input = Map.put_new(input, :a, :a)
    actual = KMap.transform(fat_input, t_map, prune: true)

    assert actual == expected
  end

  test "transform/3 does not prunes keys by default", %{
    expected: expected,
    input: input,
    t_map: t_map
  } do
    input = Map.put_new(input, :abc, 123)
    expected = Map.put_new(expected, :abc, 123)
    actual = KMap.transform(input, t_map)

    assert actual == expected
  end

  test "transform/3 allows transform_map to have more keys than input",
       %{expected: expected, input: input, t_map: t_map} do
    t_map = Map.put_new(t_map, :abc, {fn t -> t end})
    actual = KMap.transform(input, t_map)

    assert actual == expected
  end
end
