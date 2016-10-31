defmodule KitchenSink.List do

  @moduledoc """
  this module is for List functions
  """

  @doc """
  takes a list of maps, transforms it into a map of maps with their value being the value_key. basically making a
  look-up table.
  """
  def index_on(list_of_maps, take_keys, value_key) do
    take_keys = take_keys |> List.wrap |> MapSet.new |> MapSet.delete(value_key)
    lookup_transform = fn(map) ->
      {
        Map.take(map, take_keys),
        map[value_key]
      }
    end

    list_of_maps
    |> Enum.map(lookup_transform)
    |> Map.new
  end

  @doc """
  transforms a sparse list into a new list of the same size with the sparse values filled in with the previous
  non-sparse values.

  ## Example

      iex> KitchenSink.List.fill([1,"","",2,"",3,""], "")
      [1,1,1,2,2,3,3]
  """
  def fill(sparse_list, empty_matcher) do
    sparse_list_length = Enum.count(sparse_list)

    {values, indecies} =
      sparse_list
      |> Enum.with_index
      |> Enum.reject(&match?({^empty_matcher, _}, &1))
      |> Enum.unzip

    indecies
    |> Enum.drop(1)
    |> Enum.concat([sparse_list_length])
    |> Enum.zip(indecies)
    |> Enum.map(fn {last, start} -> last - start end)
    |> Enum.zip(values)
    |> Enum.flat_map(fn {amount, value} -> List.duplicate(value, amount) end)
  end
end
