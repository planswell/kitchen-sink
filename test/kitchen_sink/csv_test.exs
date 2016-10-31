defmodule KitchenSink.CsvTest do
  @moduledoc false

  use ExUnit.Case
  alias KitchenSink.Csv, as: C

  doctest KitchenSink.Csv

  test "Csv.fill" do
    expected = [1, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3]
    input = [1, nil, nil, nil, nil, 2, nil, nil, nil, 3, nil, nil, nil]

    assert expected == C.fill(input, nil)
  end
end
