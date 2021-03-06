defmodule KitchenSink.Map do
  @moduledoc """

  This module is a mixin for the elixir map namespace

  """

  import KitchenSink.Function
  # --------------------- Map.merge/1 ----------------------------------
  @doc """

  merge an array of maps! using merge/1

  ## Example:

  iex> import KitchenSink.Map
  iex> merge [%{a: 1}, %{b: 2}, %{c: 3}, %{d: 4}]
  %{a: 1, b: 2, c: 3, d: 4}

  """
  def merge([]) do
    %{}
  end

  def merge([el]) do
    el
  end

  def merge(list) when is_list(list) do
    Enum.reduce(list, reverse(&Map.merge/2))
  end

  def merge([el, el2]) do
    Map.merge(el, el2)
  end

  @doc """

  deep_merge overcomes a limitation of Map.merge in that it will merge
  trees. deep_merge will attempt to make the minimum possible change
  when it merges 2 trees.

  """
  def deep_merge(left, right, options \\ [])
      when is_map(left) and is_map(right) do
    do_deep_merge(left, right, options)
  end

  # FIXME: this should be moved to a list namespace
  def deep_merge_list(list, options \\ []) when is_list(list) do
    Enum.reduce(list, &do_deep_merge(&2, &1, options))
  end

  # This allows us to do merges with structs that
  # have partial structs so the new struct doesn't
  # overwrite all the values of the old struct
  defp do_deep_merge(left, %{__struct__: _} = right, options) do
    right = clean_struct(right)
    do_deep_merge(left, right, options)
  end

  # When the left argument is a struct, ensure that its own keys are the only
  # ones considered for the merge.
  # This guarantees that we don't convert it into a map containing new keys.
  defp do_deep_merge(%{__struct__: _} = left, right, options) do
    :maps.map(
      fn key, left_value ->
        case Map.get(right, key) do
          nil -> left_value
          right_value -> do_deep_resolve(key, left_value, right_value, options)
        end
      end,
      left
    )
  end

  defp do_deep_merge(left, right, options) do
    Map.merge(left, right, &do_deep_resolve(&1, &2, &3, options))
  end

  # Checks if one list has more items than the other and passes the rest through
  defp list_match_length(list, left, right) when length(left) > length(right) do
    rest = Enum.take(left, length(right) - length(left))
    list ++ rest
  end

  defp list_match_length(list, left, right) when length(right) > length(left) do
    rest = Enum.take(right, length(left) - length(right))
    list ++ rest
  end

  defp list_match_length(list, _left, _right), do: list

  # Key exists in both maps, and both values are maps as well.
  # These can be merged recursively.
  defp do_deep_resolve(_key, %{} = left, %{} = right, options) do
    do_deep_merge(left, right, options)
  end

  # We merge two lists so that each item gets checked and merged.
  # If there is more items in either then it gets passed through.
  defp do_deep_resolve(_key, left_list, right_list, merge_lists: true)
       when is_list(left_list) and is_list(right_list) do
    Enum.zip(left_list, right_list)
    |> Enum.map(fn {left, right} ->
      do_deep_merge(left, right, merge_lists: true)
    end)
    |> list_match_length(left_list, right_list)
  end

  # Key exists in both maps, but at least one of the values is
  # NOT a map. We fall back to standard merge behavior, preferring
  # the value on the right.
  defp do_deep_resolve(_key, _left, right, _options) do
    right
  end

  @doc """

  clean_struct take in a struct and removes the default values from it
  and returns a map

  """
  def clean_struct(%{__struct__: struct_type} = struct) do
    empty_struct = struct(struct_type, %{})
    map = Map.from_struct(struct)

    do_clean_struct = fn
      {:__struct__, _} -> false
      {key, value} -> value !== Map.get(empty_struct, key)
    end

    map
    |> Enum.filter(do_clean_struct)
    |> Enum.into(%{})
  end

  @doc """

  rename_key remaps a value from one key to another in a map

  ## Example:

  iex> import KitchenSink.Map
  iex> rename_key %{a: 1, b: 2, c: 3, d: 4}, :a, :z
  %{z: 1, b: 2, c: 3, d: 4}

  """

  def rename_key(%{} = map, options)
      when is_list(options) and length(options) === 1 do
    [{current_key, new_key}] = options
    rename_key(map, current_key, new_key)
  end

  def rename_key(%{} = map, %{} = key_map) when map_size(key_map) === 1 do
    [{current_key, new_key}] = Map.to_list(key_map)
    rename_key(map, current_key, new_key)
  end

  def rename_key(%{} = map, {current_key, new_key}) do
    rename_key(map, current_key, new_key)
  end

  def rename_key(_, _) do
    %{}
  end

  def rename_key(map, current_key, new_key, options \\ [overwrite: false])

  def rename_key(nil, _, _, _) do
    %{}
  end

  def rename_key(%{} = map, key, key, _options) do
    map
  end

  def rename_key(%{} = map, current_key, new_key, overwrite: true) do
    {popped, popped_map} = Map.pop(map, current_key)

    case popped do
      nil -> map
      _ -> Map.put(popped_map, new_key, popped)
    end
  end

  def rename_key(%{} = map, current_key, new_key, overwrite: false) do
    {popped, popped_map} = Map.pop(map, current_key)

    case {popped, Map.has_key?(map, new_key)} do
      {nil, _} -> map
      {_, true} -> map
      {_, false} -> Map.put_new(popped_map, new_key, popped)
    end
  end

  @doc """
  takes in a list of keys, and a value. creates a nested map of each successive key nested as a child, with the most
  nested map having the value `value` given to the funciton
  """
  def make_nested(value, key_list) do
    key_list
    |> Enum.reverse()
    |> Enum.reduce(value, fn key, acc -> %{key => acc} end)
    |> Map.new()
  end

  @doc """
  Similar to rename_key, however this uses a `key_map` that is larger.

  ```
  key_map = %{
    old_key1 => new_key1,
    old_key2 => new_key2,
  }
  ```

  If any of the values of the `key_map` are lists, then the output for that key will be a nested map based on the items
  in the list.

  The third argument is optional, if you use :prune then the Map returned will only contain the keys that are in the
  ``key_map``

  """
  def remap_keys(_map, key_map, prune: true) when map_size(key_map) === 0,
    do: %{}

  def remap_keys(map, key_map, prune: true) do
    renamed_key = fn map ->
      fn
        {old_key, [new_key]} ->
          value = Map.get(map, old_key)
          %{new_key => value}

        {old_key, [root_key | key_list]} ->
          value = Map.get(map, old_key)
          %{root_key => make_nested(value, key_list)}

        {old_key, new_key} ->
          value = Map.get(map, old_key)
          %{new_key => value}
      end
    end

    key_map
    |> Enum.map(renamed_key.(map))
    |> deep_merge_list
  end

  @doc """
  Similar to rename_key/3

  All of the keys that don't have a remapping are preserved in the returned Map
  """
  def remap_keys(map, key_map) do
    map_without_renamed_keys = Map.drop(map, Map.keys(key_map))

    map
    |> remap_keys(key_map, prune: true)
    |> deep_merge(map_without_renamed_keys)
  end

  @doc """
  transforms the values of a map based on a map of functions.

  input is a map of keys to functions, representing a transformer-map.
  %{
  a: a_transform_fun,
  b: b_transform_fun,
  ...
  }

  output is a function that takes a map and applies each of the transformers in the transformer-map to the corresponding
  value in the map, outputing a map where each key-value in the map has been transformed. prunes the map so only
  transformed values are output.

  fn(%{a:, b: ...}) -> %{a: a_transform_fun(a), b: b_transform_fun(b) ...}
  """
  def transform_values(transformer_map) do
    fn map ->
      transformer_map
      |> Map.new(fn {key, transform} ->
        original_value = Map.get(map, key)
        {key, transform.(original_value)}
      end)
    end
  end

  @doc """
  transforms the values of a map based on a map of functions.

  similar to transform_values/1, however doesn't return a function.
  """
  def transform_values(map, transformer_map) do
    transformer_map
    |> Map.new(fn {key, transform} ->
      original_value = Map.get(map, key)
      {key, transform.(original_value)}
    end)
  end

  @doc """
  transforms the keys and values of a map based on a map or tuple {key_list, function}.

  input is a map of keys to tuples `{key_list, function}`, representing a transformer-map.

  key_list = any || [any, ...]
  function = (any -> any)

  ## Examples

       iex> KitchenSink.Map.transform(%{b: 0.9876}, %{b: {[:b1, :b2], &Float.round(&1, 2)}}, prune: true)
       %{b1: %{b2: 0.99}}

  output is a transformed Map.  the output Map is made from appling each of the
  transformers in the transformer-map to the corresponding keys and values in the Map, outputing a Map where each
  key-value in the Map has been transformed. supplying `prune: true` prunes the map so only transformed values are
  output.
  """
  @spec transform(map, map, Keyword.t()) :: map
  def transform(map, transformation_map, [prune: true] = _opts) do
    transform_key_value = fn map, key, transform_fun ->
      Map.get(map, key) |> transform_fun.()
    end

    renamed_key = fn map ->
      fn
        # only transform values
        {old_key, {transform_fun}} ->
          value = transform_key_value.(map, old_key, transform_fun)
          %{old_key => value}

        # rename keys and transform values
        {old_key, {[new_key], transform_fun}} ->
          value = transform_key_value.(map, old_key, transform_fun)
          %{new_key => value}

        {old_key, {[root_key | key_list], transform_fun}} ->
          value = transform_key_value.(map, old_key, transform_fun)
          %{root_key => make_nested(value, key_list)}

        {old_key, {new_key, transform_fun}} ->
          value = transform_key_value.(map, old_key, transform_fun)
          %{new_key => value}
      end
    end

    t_map_keys = Map.keys(transformation_map)
    input_map_keys = Map.keys(map)

    # you can do t_map_keys -- input_map_keys here, but this is faster for large maps.
    keys_to_drop =
      MapSet.difference(MapSet.new(t_map_keys), MapSet.new(input_map_keys))
      |> MapSet.to_list()

    cleaned_t_map = Map.drop(transformation_map, keys_to_drop)

    cleaned_t_map
    |> Enum.map(renamed_key.(map))
    |> deep_merge_list
  end

  @doc """
  like transform/3 but doesn't prune the output Map, preserving key value pairs that are not part of the
  transformation_map

  ## Examples

      iex> KitchenSink.Map.transform(%{a: 1, b: 0.9876}, %{b: {[:b1, :b2], &Float.round(&1, 2)}})
      %{a: 1, b1: %{b2: 0.99}}

  output is a transformed Map.  the output Map is made from appling each of the
  transformers in the transformer-map to the corresponding keys and values in the Map, outputing a Map where each
  key-value in the Map has been transformed. supplying `prune: true` prunes the map so only transformed values are
  output.
  """
  @spec transform(map, map) :: map
  def transform(map, transformation_map) do
    keys_to_transform = Map.keys(transformation_map)
    map_without_transformed_keys = map |> Map.drop(keys_to_transform)

    map
    |> transform(transformation_map, prune: true)
    |> deep_merge(map_without_transformed_keys)
  end

  @doc """
  like transform/2, but returns a function that takes a Map to be transformed.

  ## Examples

  iex> KitchenSink.Map.transform(%{b: {[:b1, :b2], &Float.round(&1, 2)}}).(%{a: 1, b: 0.9876})
  %{a: 1, b1: %{b2: 0.99}}

  output is a function that takes a Map.  the output Map is made from appling each of the
  transformers in the transformer-map to the corresponding keys and values in the Map, outputing a Map where each
  key-value in the Map has been transformed.
  """
  def transform(transformation_map) do
    fn map ->
      transform(map, transformation_map)
    end
  end

  defp do_key_paths({key, %{} = map_key}) when map_size(map_key) === 0 do
    [[key]]
  end

  defp do_key_paths({key, %{__struct__: _}}) do
    [[key]]
  end

  defp do_key_paths({key, value}) when is_map(value) do
    sub_keys = key_paths(value)

    Enum.map(sub_keys, &Enum.concat([key], &1))
  end

  defp do_key_paths({key, _value}) do
    [[key]]
  end

  @doc """
  Takes a Map and returns a List of Paths.

  A Path is a list of keys that you can use to access a leaf node/value in a Map. Useful with `get_in` Access syntax.
  `get_in(my_map, [:a, :b, :c])`

  ## Example
       iex> KitchenSink.Map.key_paths(%{a: %{b: 1, c: 2}, d: 3})
       [[:a, :b], [:a, :c], [:d]]

  """
  def key_paths(map) when is_map(map) do
    Enum.flat_map(map, &do_key_paths/1)
  end

  @doc """
  Takes a list of tuples of path(s) that describe from->to remappings of an object

  one can consider this to be like remap_keys or Map.take, but for nested keys.  for each tuple of paths, the value of
  the first path will move to the second path. if there is only one path provided, then this will act more like Map.take

  ## Example
       iex> KitchenSink.Map.remapper(%{a: %{b: 1, c: 2}, d: 3}, [{[:a, :c]}])
       %{a: %{c: 2}}

       iex> KitchenSink.Map.remapper(%{a: %{b: 1, c: 2}, d: 3}, [{[:a, :c], [:d, :z]}])
       %{d: %{z: 2}}

       iex> KitchenSink.Map.remapper(%{a: %{b: 1, c: 2}, d: 3}, [{[:e], [:d, :c]}])
       %{}

  This function prunes the input map
  """
  def remapper(map, remap_list, lookup_nil_val \\ %{}) do
    remap_helper = fn {from_path, to_path} ->
      val = get_in(map, from_path)

      case val do
        nil -> lookup_nil_val
        _ -> make_nested(val, to_path)
      end
    end

    remap = fn
      {from_path} -> remap_helper.({from_path, from_path})
      {_from_path, _to_path} = from_to -> remap_helper.(from_to)
    end

    remap_list
    |> Enum.map(remap)
    |> deep_merge_list
  end

  @doc """
  Compares two maps and returns a list of paths (used in Access) and the differences in values between the maps

  iex> KitchenSink.Map.diff(%{a: 1, b: 2}, %{a: 3, b: 2})
  [{[:a], 1, 3}]

  iex> KitchenSink.Map.diff(%{c: %{d: 1}}, %{c: %{d: 4}})
  [{[:c, :d], 1, 4}]

  iex> KitchenSink.Map.diff(%{c: %{d: 1, e: 7}}, %{c: %{d: 4}})
  [
    {[:c, :d], 1, 4},
    {[:c, :e], 7, nil}
  ]

  iex> KitchenSink.Map.diff(%{c: %{d: 1}}, %{c: %{d: 4, e: 7}})
  [
    {[:c, :d], 1, 4},
    {[:c, :e], nil, 7}
  ]
  """
  def diff(%{} = primary, %{} = secondary) do
    primary_paths =
      primary
      |> key_paths()
      |> MapSet.new()

    paths =
      secondary
      |> key_paths()
      |> Enum.into(primary_paths)

    compare_path = fn path ->
      primary_val = get_in(primary, path)
      secondary_val = get_in(secondary, path)
      {path, primary_val, secondary_val}
    end

    paths
    |> Enum.map(compare_path)
    |> Enum.reject(&match?({_, val, val}, &1))
  end

  def is_enumerable(%{__struct__: module}), do: is_enumerable(module)
  def is_enumerable(type) when is_map(type), do: true

  def is_enumerable(type) do
    Protocol.assert_impl!(Enumerable, type)
    true
  rescue
    ArgumentError -> false
  end

  def do_trim(map, empty_val_fn?) do
    map
    |> Enum.map(fn
      {key, %{} = children} ->
        if is_enumerable(children) do
          {key, do_trim(children, empty_val_fn?)}
        else
          {key, children}
        end

      {key, val} ->
        {key, val}
    end)
    # we need to do the filter step after map
    |> Enum.reject(empty_val_fn?)
    |> Map.new()
  end

  @doc """
  Walks an object and recursively removes nodes with nil/empty values

  Works for Structs as well!
  """
  def trim(%{} = map) do
    empty_val? = fn
      {_key, %{} = map} when map_size(map) == 0 -> true
      {_key, nil} -> true
      {_key, _} -> false
    end

    do_trim(map, empty_val?)
  end

  def trim(%{} = map, empty_val_fn?) do
    do_trim(map, empty_val_fn?)
  end
end
