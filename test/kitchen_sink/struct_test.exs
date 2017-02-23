defmodule KitchenSink.StructTest do
  @moduledoc false

  use ExUnit.Case

  alias KitchenSink.Struct

  describe "to_map()" do
    test "empty struct converts to map with nil fields" do
      assert Struct.to_map(%TestStruct{}) == %{age: nil, name: nil}
    end

    test "nested struct converts to map" do
      assert Struct.to_map(
        %TestStructNested{
          field1: %TestStruct{},
          field2: %TestStruct{},
        }) == %{
        field1: %{
          age: nil,
          name: nil,
        },
        field2: %{
          age: nil,
          name: nil,
        }
      }
    end
  end
end
