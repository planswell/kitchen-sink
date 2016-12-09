defmodule KitchenSink.MergeTest do
  @moduledoc false

  use ExUnit.Case
  alias KitchenSink.Merge

  doctest KitchenSink.Merge

  describe "Merge.path/3" do
    test "path as atom" do
      expected = %{a: %{b: "new", c: "don't change"}}
      actual = Merge.path(
        %{a: %{b: "change", c: "don't change"}},
        %{a: %{b: "new", d: "don't merge"}},
        :b)

      assert expected == actual
    end
  end
end
