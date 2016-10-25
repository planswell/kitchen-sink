defmodule KitchenSink.MathTest do
  @moduledoc false

  use ExUnit.Case
  import KitchenSink.Math

  doctest KitchenSink.Math

  test "div function" do
    assert 0 == div(0, 0, 0)
    assert 0.0 == div(0, 0, 0.0)
    assert 0 == div(1.0, 0, 0)
    assert 2 == div(4, 2, 0)
    assert 2.0 == div(4.0, 2, 0)
  end
end
