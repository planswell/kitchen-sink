defmodule KitchenSink.Misc do

  @moduledoc """

  """

  @doc """

  """

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
        |> Enum.to_list
        |> Map.new
    end
  end

  def first(list), do: nth(0).(list)
  def second(list), do: nth(1).(list)
  def third(list), do: nth(2).(list)
  def fourth(list), do: nth(3).(list)
  def fifth(list), do: nth(4).(list)
  def sixth(list), do: nth(5).(list)
  def seventh(list), do: nth(6).(list)
  def eighth(list), do: nth(7).(list)
  def nineth(list), do: nth(8).(list)
  def tenth(list), do: nth(9).(list)

end
