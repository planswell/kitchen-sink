defmodule KitchenSink.KeywordTest do
  @moduledoc false

  use ExUnit.Case
  alias KitchenSink.Keyword

  doctest KitchenSink.Keyword

  test "keyword with 2 element produces the deep_merge of those 2 according to merge/2 rules" do
    assert Keyword.deep_merge([a: 1], [b: 1]) == [a: 1, b: 1]
    assert Keyword.deep_merge([a: 1], [a: 2]) == [a: 2]
    assert Keyword.deep_merge([a: [b: 1, c: 1]], [a: [b: 2]]) == [a: [c: 1, b: 2]]
    assert Keyword.deep_merge([a: [b: 1, c: nil]], [a: [b: 2, c: 1]]) == [a: [b: 2, c: 1]]
    assert Keyword.deep_merge([a: nil], [a: [b: 2, c: 1]]) == [a: [b: 2, c: 1]]
  end
end
