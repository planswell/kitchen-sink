defmodule KitchenSink.Struct do
  @moduledoc "functions that apply to structs"

  defp do_deep_resolve_struct_to_map({key, value}, acc, options) when is_list value do
    result = Enum.map(value, &do_deep_struct_to_map(&1, options))
    Map.put(acc, key, result)
  end
  defp do_deep_resolve_struct_to_map({key, value}, acc, options) when is_map value do
    result =
      value
      |> Map.drop(Keyword.get(options, :drop, []))
      |> do_deep_struct_to_map(options)
    Map.put(acc, key, result)
  end
  defp do_deep_resolve_struct_to_map({key, value}, acc, _) do
    Map.put(acc, key, value)
  end
  defp do_deep_struct_to_map(struct1, options) when is_map struct1 do
    if Map.has_key?(struct1, :__struct__) do
      if Keyword.get(options, :clean_struct, false) do
        KitchenSink.Map.clean_struct(struct1)
      else
        Map.from_struct(struct1)
      end
    else
      struct1
    end
    |> Map.drop(Keyword.get(options, :drop, []))
    |> Enum.reduce(%{}, &do_deep_resolve_struct_to_map(&1, &2, options))
  end
  defp do_deep_struct_to_map(value, _) do
    value
  end

  @doc "convert a struct to a map removing all structness"
  def to_map(struct1, options \\ []) do
    do_deep_struct_to_map(struct1, options)
  end
end
