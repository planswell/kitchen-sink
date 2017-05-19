defmodule KitchenSink.Walk do

  def is_enumerable(%{__struct__: module}), do: is_enumerable(module)
  def is_enumerable(type) when is_map(type), do: true
  @lint {Credo.Check.Readability.PreferImplicitTry, false}
  def is_enumerable(type) do
    try do
      Protocol.assert_impl!(Enumerable, type)
      true
    rescue
      ArgumentError -> false
    end
  end

  # FIXME post-walk not implemented yet
  defp do_walk(map, pre_transform, post_transform) do
    not_nil = fn x -> not is_nil(x) end

    mapper = fn
      {key, children} when is_list(children) ->
        {key, children |> Enum.map(&do_walk(&1, pre_transform, post_transform))}
      {key, %{} = children} ->
      if is_enumerable(children) do
        {key, do_walk(children, pre_transform, post_transform)}
      else
        {key, children}
      end
      {key, val} = kv -> kv
    end

    map
    |> Enum.map(pre_transform)
    |> Enum.filter_map(not_nil, mapper)
    |> Map.new()
  end

  @doc """
  Walks an object and recursively applying a transform at each step
  """
  def prewalk(%{} = map, transform) do
    identity = fn x -> x end
    do_walk(map, transform, identity)
  end
end
