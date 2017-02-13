defmodule KitchenSink.MathTest do
  @moduledoc false

  use ExUnit.Case
  import KitchenSink.Math

  doctest KitchenSink.Math, import: true

  test "div function" do
    assert 0 == div(0, 0, 0)
    assert 0.0 == div(0, 0, 0.0)
    assert 0 == div(1.0, 0, 0)
    assert 2 == div(4, 2, 0)
    assert 2.0 == div(4.0, 2, 0)
  end

  describe "round_up_to_multiple/2" do
    test "stays put on zero" do
      assert round_up_to_multiple(0, 1) == 0
      assert round_up_to_multiple(0, 3) == 0
      assert round_up_to_multiple(0, 217) == 0
    end

    test "negative numbers round up toward infinity" do
      assert round_up_to_multiple(-7.5, 5) == -5
      assert round_up_to_multiple(-11, 5) == -10
    end

    test "significance multiple must not be zero" do
      assert_raise ArgumentError, fn ->
        round_up_to_multiple(5, 0)
      end
    end
  end
end
