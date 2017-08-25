defmodule KitchenSink.List.IndexBy do
  @moduledoc false

  @spec index_by(list(map), function | atom | list(atom)) :: map
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
