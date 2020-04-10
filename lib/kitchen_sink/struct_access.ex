defmodule KitchenSink.StructAccess do
  @moduledoc """

  This module makes structs use Access to get and change
  their values.

  To use it for your struct do
  ```
  use KitchenSink.StructAccess
  ```

  """

  defmacro __using__(_opts) do
    quote do
      def fetch(map, key) when is_map(map) do
        Map.fetch(map, key)
      end

      def get_and_update(map, key, fun) when is_map(map) do
        Map.get_and_update(map, key, fun)
      end
    end
  end
end
