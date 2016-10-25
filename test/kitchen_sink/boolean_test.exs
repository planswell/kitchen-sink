defmodule KitchenSink.BooleanTest do
  @moduledoc false

  use ExUnit.Case
  alias KitchenSink.Boolean

  doctest KitchenSink.Boolean

  test "boolean parse" do
    assert Boolean.parse("TRUE") === true
    assert Boolean.parse("FALSE") === false
    assert Boolean.parse("true") === true
    assert Boolean.parse("false") === false
    assert Boolean.parse("t") === true
    assert Boolean.parse("f") === false
    assert Boolean.parse("on") === true
    assert Boolean.parse("off") === false
    assert Boolean.parse("yes") === true
    assert Boolean.parse("no") === false
    assert Boolean.parse("y") === true
    assert Boolean.parse("n") === false
    assert Boolean.parse(1) === true
    assert Boolean.parse("falsy") === :error
    assert Boolean.parse(2) === :error
  end

end
