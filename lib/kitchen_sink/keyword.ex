defmodule KitchenSink.Keyword do
  @moduledoc """

  This module is a mixin for the elixir keyword namespace

  """

  def deep_merge(left, right) do
    do_deep_merge(left, right)
  end

  defp do_deep_merge(left, right) when is_list(left) and is_list(right) do
    Keyword.merge(left, right, &do_resolve/3)
  end

  defp do_resolve(_, left, right) when is_list(left) and is_list(right) do
    do_deep_merge(left, right)
  end

  defp do_resolve(_, _left, right) do
    right
  end
end
