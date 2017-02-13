defmodule KitchenSink.Assert do
  @moduledoc false

  alias KitchenSink.Map, as: KMap

  import ExUnit.Assertions

  @doc """
  Similar to ExUnit.Assertions.assert_in_delta, however works for Maps.

  Both Maps must be the same shape. any difference in structure will
  cause an error. In the future this restriction can be removed,
  without much effort.

  Assert.assertish will compare each leaf node in both maps, if the nodes are
  number then will do a delta compare, if nodes are something else
  then will do a `==` compare.

  Any nodes that fail this test will be displayed in nice colors in the assert error message.
  """
  @lint {Credo.Check.Refactor.ABCSize, false}
  _ = @lint # https://github.com/rrrene/credo/issues/291
  def assertish(expected, actual, epsilon, msg \\ "") when is_map(actual) and is_map(expected) do
    a_paths = KMap.key_paths(actual) |> Enum.sort
    e_paths = KMap.key_paths(expected) |> Enum.sort

    assert e_paths == a_paths

    test_results =
      a_paths
      |> Enum.map(fn path -> {path, {get_in(expected, path), get_in(actual, path)}} end)
      |> Enum.map(fn {path, {expected, actual} = test} ->
          path_str = pretty_path(path)
          error_msg =
            IO.ANSI.format(
              [
                msg,
                :cyan,
                "error comparing path: ",
                :magenta,
                :bright,
                "#{path_str}",
                :reset,
                " -> ",
                :green,
                "#{inspect expected}",
                :reset,
                " == ",
                :red,
                "#{inspect actual}",
                :reset],
              true)
              |> IO.chardata_to_string #because asserts are macros :(

          do_assertish(test, epsilon, error_msg)
        end)
      |> Enum.filter(&match?({false, _}, &1))
      |> Enum.map(&elem(&1, 1))

    if Enum.count(test_results) > 0 do
      # print out all of the error messages
      error_report = Enum.join(test_results, "\n")
      assert false, error_report
    end
  end

  defp do_assertish({%{__struct__: _} = expected, %{__struct__: _} = actual}, _espilon, msg) do
    {expected == actual, msg}
  end
  defp do_assertish({expected, actual}, epsilon, msg) when is_number(actual) and is_number(expected) do
    {abs(expected - actual) < epsilon, msg}
  end
  defp do_assertish({expected, actual}, _epsilon, msg) do
    {expected == actual, msg}
  end

  defp pretty_path(path) do
    path |> Enum.join(".")
  end
end
