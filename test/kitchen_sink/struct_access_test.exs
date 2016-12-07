defmodule KitchenSink.StructAccessTest do
  @moduledoc false

  use ExUnit.Case

  test "empty struct should have nil for values" do
    assert get_in(%TestStruct{}, [:name]) == nil
  end

  test "struct should have get value" do
    assert get_in(%TestStruct{name: "Test User"}, [:name]) == "Test User"
  end

  test "struct should be able be changed" do
    assert put_in(%TestStruct{}, [:name], "Test User") == %TestStruct{name: "Test User"}
  end
end
