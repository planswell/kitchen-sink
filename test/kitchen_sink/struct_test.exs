defmodule KitchenSink.StructTest do
  @moduledoc false

  use ExUnit.Case

  alias KitchenSink.Struct

  describe "to_map()" do
    test "empty struct converts to map with nil fields" do
      assert Struct.to_map(%TestStruct{}) == %{age: nil, name: nil}
    end

    test "nested struct converts to map" do
      input = %TestStructNested{
        field1: %TestStruct{},
        field2: %TestStruct{},
      }
      expected = %{
        field1: %{
          age: nil,
          name: nil,
        },
        field2: %{
          age: nil,
          name: nil,
        }
      }
      assert Struct.to_map(input) == expected
    end

    test "struct with list of primitives converts to map" do
      input = %TestStructNested{
        field1: %TestStruct{},
        field2: ["something", "else"]
      }
      expected = %{
        field1: %{
          age: nil,
          name: nil
        },
        field2: ["something", "else"]
      }
      assert Struct.to_map(input) == expected
    end
  end
end
