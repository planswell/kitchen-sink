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
    assert Boolean.parse(1) === true
    assert Boolean.parse("falsy") === :error
    assert Boolean.parse(2) === :error
  end

end
