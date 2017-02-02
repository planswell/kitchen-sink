defmodule KitchenSink.List.IndexBy do
  @moduledoc false

  @doc """
  creates and indexed list from a list of maps using a key_function or
  a path. if a path is given then the access module will be used.

  This function is very similar to group_by, however the values will
  not be grouped. there should be a 1-to-1 mapping for the key_fun to
  item in the list. if it's possible that you could have a different
  mapping ratio, dupe keys will be dropped, according to Map.new logic
  """
  def index_by(list, key_fun) when is_function(key_fun) do
    indices = Enum.map(list, key_fun)
    Enum.zip(indices, list) |> Map.new()
  end
  def index_by(list, path) do
    index_path = List.wrap(path)
    indices = get_in(list, [Access.all() | index_path])
    Enum.zip(indices, list) |> Map.new()
  end
end
