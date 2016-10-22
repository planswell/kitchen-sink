defmodule KitchenSink.List do

  @moduledoc """
  this module is for List functions
  """

  @doc """
  This will take a 2D array and map all of it's indicies [x,y] -> [y,x]
  """
  def transpose(matrix) when is_list(matrix) do
    matrix
    |> List.zip
    |> Enum.map(&Tuple.to_list(&1))
  end

end
