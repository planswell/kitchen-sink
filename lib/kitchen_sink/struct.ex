defmodule KitchenSink.Struct do
  @moduledoc "functions that apply to structs"

  defp do_deep_struct_to_map({key, value}, acc) when is_list value do
    result = Enum.map(value, &do_deep_struct_to_map/1)
    Map.put(acc, key, result)
  end
  defp do_deep_struct_to_map({key, value}, acc) when is_map value do
    result = do_deep_struct_to_map(value)
    Map.put(acc, key, result)
  end
  defp do_deep_struct_to_map({key, value}, acc) do
    Map.put(acc, key, value)
  end
  defp do_deep_struct_to_map(struct1) when is_map struct1 do
    if Map.has_key?(struct1, :__struct__) do
      Map.from_struct(struct1)
    else
      struct1
    end
    |> Enum.reduce(%{}, &do_deep_struct_to_map/2)
  end

  @doc "convert a struct to a map removing all structness"
  def to_map(struct1) do
    do_deep_struct_to_map(struct1)
  end
end
