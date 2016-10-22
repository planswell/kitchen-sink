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

  def identity(x), do: x

  def compose(functions) when is_list(functions) do
    functions = Enum.reverse(functions)
    fn(input) ->
      Enum.reduce(functions, input, fn (fun, acc) ->
        fun.(acc)
      end)
    end
  end

  def pipe(functions) when is_list(functions) do
    fn(input) ->
      Enum.reduce(functions, input, fn (fun, acc) ->
        fun.(acc)
      end)
    end
  end

  @doc """
  from clojure. takes in a list of functions, outputs a function that
  takes in a list of values, then applies the functions to each
  value. sorta like a super Enum.map
  """
  def juxt(functions) when is_list(functions) do
    #good for optimiztion
    super_fun = fn x -> Enum.map(functions, fn fun -> fun.(x) end) end
    fn(input_list) ->
      Enum.map(input_list, super_fun)
    end
  end
end
