defmodule KitchenSink.Misc do
  @moduledoc false

  @doc """
  Return a function which returns the *n*th element (zero based) of a collection
  which is passed to it.

      iex> f = nth(2)
      iex> f.(["a", "b", "c", "d", "e"])
      "c"

  Utility functions `first/1`, `second/1`, ... `tenth/1` are provided as
  convenient short cuts. Be aware that `first/1` is really `nth(0)`.

      iex> third(["a", "b", "c", "d", "e"])
      "c"
  """
  @spec nth(integer) :: (list | tuple | map -> any | no_return)
  def nth(index) do
    fn
      list when is_list(list) ->
        Enum.at(list, index)

      tuple when is_tuple(tuple) ->
        elem(tuple, index)

      map when is_map(map) ->
        map
        |> Stream.take(index + 1)
        |> Stream.drop(index)
        |> Enum.to_list()
        |> Map.new()
    end
  end

  @doc false
  def first(list), do: nth(0).(list)

  @doc false
  def second(list), do: nth(1).(list)

  @doc false
  def third(list), do: nth(2).(list)

  @doc false
  def fourth(list), do: nth(3).(list)

  @doc false
  def fifth(list), do: nth(4).(list)

  @doc false
  def sixth(list), do: nth(5).(list)

  @doc false
  def seventh(list), do: nth(6).(list)

  @doc false
  def eighth(list), do: nth(7).(list)

  @doc false
  def ninth(list), do: nth(8).(list)

  @doc false
  def nineth(list), do: nth(8).(list)

  @doc false
  def tenth(list), do: nth(9).(list)
end
