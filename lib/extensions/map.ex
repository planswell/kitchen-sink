defmodule Planswell.Extensions.Map do
  @moduledoc """

  This module is a mixin for the elixir map namespace

  """

  import Planswell.Extensions.Function
  # --------------------- Map.merge/1 ----------------------------------
  @doc """

merge an array of maps! using merge/1

  ## Example:

  iex> Map.merge [%{a: 1}, %{b: 2}, %{c: 3}, %{d: 4}]
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
    Map.merge(left, right, &deep_resolve/3)
  end

  def deep_merge(list) when is_list(list) do
    Enum.reduce list, reverse(&deep_merge/2)
  end

  # Key exists in both maps, and both values are maps as well.
  # These can be merged recursively.
  defp deep_resolve(_key, left = %{}, right = %{}) do
    deep_merge(left, right)
  end

  # Key exists in both maps, but at least one of the values is
  # NOT a map. We fall back to standard merge behavior, preferring
  # the value on the right.
  defp deep_resolve(_key, _left, right) do
    right
  end

  @doc """

  rename_key remaps a value from one key to another in a map

  ## Example:

  iex> Map.rename_key %{a: 1, b: 2, c: 3, d: 4}, :a, :z
  %{z: 1, b: 2, c: 3, d: 4}

  """

  def rename_key(map, key_map) when is_map(key_map) and map_size(map) === 1 do
    [{current_key, new_key}] = Map.to_list key_map
    rename_key(map, current_key, new_key)
  end

  def rename_key(nil, _) do
    %{}
  end

  def rename_key(map, _) when map_size(map) === 0 do
    %{}
  end

  def rename_key(map, {current_key, new_key}) do
    rename_key(map, current_key, new_key)
  end

  def rename_key(nil, _, _) do
    %{}
  end

  def rename_key(map, _, _) when map_size(map) === 0 do
    %{}
  end

  def rename_key(map, key, key) do
    map
  end

  def rename_key(map, current_key, new_key) do
    {popped, popped_map} = Map.pop(map, current_key)

    case popped do
      nil -> map
      _ -> Map.put_new(popped_map, new_key, popped)
    end
  end

  def rename_key() do
    %{}
  end

  end
