defmodule KitchenSink.CSVTest do
  @moduledoc false

  use ExUnit.Case
  alias KitchenSink.CSV

  doctest KitchenSink.CSV

  test "CSV.fill" do
    expected = [1, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3]
    input = [1, nil, nil, nil, nil, 2, nil, nil, nil, 3, nil, nil, nil]

    assert expected == CSV.fill(input, nil)
  end
end
