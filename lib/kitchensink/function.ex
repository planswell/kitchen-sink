defmodule KitchenSink.Function do

  @moduledoc """
  this module is for higher order functions
  """

  @doc """
  reverses the arguments of a function.
  """
  def reverse(fun) when is_function(fun, 2) do
    fn(arg1, arg2) -> fun.(arg2, arg1) end
  end

end
