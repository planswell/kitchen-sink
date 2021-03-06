defmodule KitchenSink.StructTest do
  @moduledoc false

  use ExUnit.Case

  alias KitchenSink.Struct

  describe "to_map()" do
    test "empty struct converts to map with no fields" do
      assert Struct.to_map(%TestStruct{}) == %{age: nil, name: nil}
    end

    test "empty struct converts to map with no fields clean struct" do
      assert Struct.to_map(%TestStruct{}, clean_struct: true) == %{}
    end

    test "nested struct converts to map" do
      input = %TestStructNested{
        field1: %TestStruct{},
        field2: %TestStruct{}
      }

      expected = %{
        field1: %{
          age: nil,
          name: nil
        },
        field2: %{
          age: nil,
          name: nil
        }
      }

      assert Struct.to_map(input) == expected
    end

    test "nested struct converts to map clean struct" do
      input = %TestStructNested{
        field1: %TestStruct{},
        field2: %TestStruct{}
      }

      expected = %{
        field1: %{},
        field2: %{}
      }

      assert Struct.to_map(input, clean_struct: true) == expected
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

    test "struct with list of primitives converts to map clean struct" do
      input = %TestStructNested{
        field1: %TestStruct{},
        field2: ["something", "else"]
      }

      expected = %{
        field1: %{},
        field2: ["something", "else"]
      }

      assert Struct.to_map(input, clean_struct: true) == expected
    end

    test "struct with map with nested unwanted key drops key correctly" do
      input = %TestStructNested{
        field1: "Hello",
        field2: %{
          wanted: "whatever",
          unwanted: "go away",
          other: %{
            something: "wee",
            unwanted: "does not want",
            yet_another: %{
              cool: "beans",
              unwanted: {:__junk__, 3, 5}
            }
          }
        }
      }

      expected = %{
        field1: "Hello",
        field2: %{
          wanted: "whatever",
          other: %{
            something: "wee",
            yet_another: %{
              cool: "beans"
            }
          }
        }
      }

      assert Struct.to_map(input, drop: [:unwanted]) == expected
    end
  end
end
