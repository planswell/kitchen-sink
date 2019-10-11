defmodule KitchenSink.List do
  @moduledoc """
  this module is for List functions
  """

  alias __MODULE__.IndexBy

  @doc """
  Creates an indexed list from a list of maps using a key_function or a path.
  If a path is given then the `Access` module will be used.

  This function is very similar to `group_by`, however the values will not be
  grouped. There should be a 1-to-1 mapping for the key_fun to item in the list.
  For different mapping ratio duplicate keys will be dropped, according to
  `Map.new/1` logic

  ## Examples

      iex> [
      ...>   %{name: :a, other: 1},
      ...>   %{name: :b, other: 4}
      ...> ] |> index_by(:name)
      %{
        a: %{name: :a, other: 1},
        b: %{name: :b, other: 4}
      }
  """
  defdelegate index_by(list, path), to: IndexBy

  @doc """
  Takes a list of maps, transforms it into a map of maps with their value being
  the value_key. Basically making a look-up table.

  ## Examples

      iex> [
      ...>   %{a: 1, b: "x"},
      ...>   %{a: 2, b: "y"},
      ...>   %{a: 3, b: "z"}
      ...> ] |> index_on([:a], :b)
      %{
        %{a: 1} => "x",
        %{a: 2} => "y",
        %{a: 3} => "z"
      }

      iex> [
      ...>   %{a: 1, b: "x"},
      ...>   %{a: 2, b: "y"},
      ...>   %{a: 3, b: "z"}
      ...> ] |> index_on(:a, :b)
      %{
        %{a: 1} => "x",
        %{a: 2} => "y",
        %{a: 3} => "z"
      }

  """
  @spec index_on(list(map), list(any), any) :: map
  def index_on(list_of_maps, take_keys, value_key) do
    take_keys = take_keys |> List.wrap |> MapSet.new |> MapSet.delete(value_key) |> MapSet.to_list()
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
  A convenient version of what is perhaps the most common use-case for map:
  extracting a list of property values.

  With a List of Maps, extract 1 value defined by the key you give to pluck.

  ## Examples

      iex> pluck([%{b: 1}, %{a: 2}, %{a: 3}], :a)
      [nil, 2, 3]

  """
  @spec pluck(list(map), any) :: list
  def pluck(list_of_maps, key) do
    Enum.map(list_of_maps, &Map.get(&1, key))
  end
end
