defmodule KitchenSink.StructEnum do
  @moduledoc """

  This module makes structs Enumerable which means that you
  can use Enum functions on them. The format of default
  values we are using is setting them to nil so count uses
  that.

  To use it for your struct do
  ```
  use KitchenSink.StructEnum
  ```

  """

  defmacro __using__(_opts) do
    caller_mod = __CALLER__.context_modules |> List.first
    quote do
      defimpl Enumerable, for: __MODULE__ do
        def count(map) do
          new_map = :maps.filter(fn (_, v) -> v != nil end, map)
          {:ok, map_size(new_map) - 1}
        end

        def member?(map, {key, value}) do
          {:ok, match?({:ok, ^value}, :maps.find(key, map))}
        end

        def member?(_map, _other) do
          {:ok, false}
        end

        def slice(_map), do: {:error, __MODULE__}

        def reduce(map, acc, fun) do
          :maps.remove(:__struct__, map)
          |> :maps.to_list
          |> do_reduce(acc, fun)
        end

        defp do_reduce(_,       {:halt, acc}, _fun),   do: {:halted, acc}
        defp do_reduce(list,    {:suspend, acc}, fun), do: {:suspended, acc, &do_reduce(list, &1, fun)}
        defp do_reduce([],      {:cont, acc}, _fun),   do: {:done, acc}
        defp do_reduce([h | t], {:cont, acc}, fun),    do: do_reduce(t, fun.(h, acc), fun)
      end
      defimpl Collectable, for: __MODULE__ do
        def into(original) do
          {original, fn
            map, {:cont, {k, v}} -> :maps.put(k, v, map)
            map, :done -> struct(unquote(caller_mod), map)
            _, :halt -> :ok
          end}
        end
      end
    end
  end
end
