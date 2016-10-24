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
    Enum.reduce list, reverse(&Map.merge/2)
  end

  def merge([el, el2]) do
    Map.merge(el, el2)
  end

  @doc"""

  deep_merge overcomes a limitation of Map.merge in that it will merge
  trees. deep_merge will attempt to make the minimum possible change
  when it merges 2 trees.

  """
  def deep_merge(left, right) do
    do_deep_merge(left, right)
  end

  def deep_merge(list) when is_list(list) do
    Enum.reduce list, reverse(&do_deep_merge/2)
  end

  # This allows us to do merges with structs that
  # have partial structs so the new struct doesn't
  # overwrite all the values of the old struct
  defp do_deep_merge(left, %{__struct__: _} = right) do
    right = clean_struct(right)
    do_deep_merge(left, right)
  end

  defp do_deep_merge(left, right) do
    Map.merge(left, right, &do_deep_resolve/3)
  end

  # Key exists in both maps, and both values are maps as well.
  # These can be merged recursively.
  defp do_deep_resolve(_key, left = %{}, right = %{}) do
    do_deep_merge(left, right)
  end

  # Key exists in both maps, but at least one of the values is
  # NOT a map. We fall back to standard merge behavior, preferring
  # the value on the right.
  defp do_deep_resolve(_key, _left, right) do
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

  def rename_key(%{} = map, options) when is_list(options) and length(options) === 1 do
    [{current_key, new_key}] = options
    rename_key(map, current_key, new_key)
  end

  def rename_key(%{} = map, %{} = key_map) when map_size(key_map) === 1 do
    [{current_key, new_key}] = Map.to_list key_map
    rename_key(map, current_key, new_key)
  end

  def rename_key(%{} = map, {current_key, new_key}) do
    rename_key(map, current_key, new_key)
  end

  def rename_key(_,_) do
    %{}
  end

  def rename_key(%{} = map, key, key) do
    map
  end

  def rename_key(%{} = map, current_key, new_key) do
    {popped, popped_map} = Map.pop(map, current_key)

    case popped do
      nil -> map
      _ -> Map.put_new(popped_map, new_key, popped)
    end
  end

  def rename_key(_,_,_) do
    %{}
  end

  def unquote(:"$handle_undefined_function")(function, args) do
    apply(Map, function, args)
  end
end
