defmodule KitchenSink.QuotedMapEnum do
  defmacro __using__(_opts) do
    quote do
      defimpl Enumerable, for: Tuple do
        def count({:%{}, _, keyword_list}) do
          {:ok, length(keyword_list)}
        end

        def member?({:%{}, _, keyword_list}, {key, value}) do
          {:ok, match?({^key, ^value}, :proplists.lookup(key, keyword_list))}
        end

        def member?(_map, _other) do
          {:ok, false}
        end

        def reduce({:%{}, _, keyword_list}, acc, fun) do
          keyword_list
          |> do_reduce(acc, fun)
        end

        defp do_reduce(_,       {:halt, acc}, _fun),   do: {:halted, acc}
        defp do_reduce(list,    {:suspend, acc}, fun), do: {:suspended, acc, &do_reduce(list, &1, fun)}
        defp do_reduce([],      {:cont, acc}, _fun),   do: {:done, acc}
        defp do_reduce([h | t], {:cont, acc}, fun),    do: do_reduce(t, fun.(h, acc), fun)
      end
    end
  end
end
