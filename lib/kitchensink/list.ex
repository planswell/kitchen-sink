defmodule KitchenSink.List do

  @moduledoc """
  this module is for List functions
  """


  @doc """
  takes a list of maps, transforms it into a map of maps with their value being the value_key. basically making a
  look-up table.
  """
  def index_on(list_of_maps, take_keys, value_key) do
    take_keys = MapSet.new(take_keys) |> MapSet.delete(value_key)
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


end
