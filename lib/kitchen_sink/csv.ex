defmodule KitchenSink.CSV do
  @moduledoc """
  This module is for CSV helper functions.
  """

  @doc """
  transforms a sparse list into a new list of the same size with the sparse values filled in with the previous
  non-sparse values.

  ## Example

       iex> KitchenSink.CSV.fill([1,"","",2,"",3,""], "")
       [1,1,1,2,2,3,3]
  """
  def fill(sparse_list, empty_matcher) do
    sparse_list_length = Enum.count(sparse_list)

    {values, indices} =
      sparse_list
      |> Enum.with_index()
      |> Enum.reject(&match?({^empty_matcher, _}, &1))
      |> Enum.unzip()

    indices
    |> Enum.drop(1)
    |> Enum.concat([sparse_list_length])
    |> Enum.zip(indices)
    |> Enum.map(fn {last, start} -> last - start end)
    |> Enum.zip(values)
    |> Enum.flat_map(fn {amount, value} -> List.duplicate(value, amount) end)
  end
end
