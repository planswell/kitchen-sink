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

  test "ceil function stays put on zero" do
    assert ceil(0, 1) == 0
    assert ceil(0, 3) == 0
    assert ceil(0, 217) == 0
  end

  test "negative numbers ceil toward infinity" do
    assert ceil(-7.5, 5) == -5
    assert ceil(-11, 5) == -10
  end
end
